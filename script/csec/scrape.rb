#!/usr/bin/env ruby

# This script constructs a csv for scheduling course surveys from the EECS
# schedule.
#  + http://www.eecs.berkeley.edu/Scheduling/EE/schedule.html
#  + http://www.eecs.berkeley.edu/Scheduling/CS/schedule.html
#
# It also scrapes enrollment data from osoc.berkeley.edu. They aren't real big
# fans of people doing that, but I think if we limit ourselves to not real-time
# stats, we might be okay. If the API ever works, we should try to use that.
#  + http://osoc.berkeley.edu/OSOC/osoc
#
# In theory, this could break at any time, but it's probably okay since all
# those pages are auto-generated. It should take <10 seconds to run; if it takes
# longer, OSOC probably doesn't like us.
#  - brian

require 'nokogiri'
require 'open-uri'
require 'csv'
require 'set'

EE_URL = 'http://www.eecs.berkeley.edu/Scheduling/EE/schedule.html'
CS_URL = 'http://www.eecs.berkeley.edu/Scheduling/CS/schedule.html'
OSOC_URL = 'http://osoc.berkeley.edu/OSOC/osoc'

# Use Nokogiri to actually scrape the pages

def parse_schedule(url)
  # Turn class schedule into an array of arrays.
  page = Nokogiri::HTML(open(url))
  schedule = page.search('table')[5]
  rows = schedule.search('tr')
  rows.map { |row| parse_row(row) }
end

def parse_row(row)
  # Return an array of [CCN, Course, Section, Type, Title, Instructor, Day/Time,
  # Location, Units, Exam Group, is_main?]
  cells = row.search('th', 'td').map { |cell| cell.content }
  cells << (!row.search('strong').empty?) # if class is main section
end

def update_enrollment(courses, term = "SP")
  # Mutate the Course objects and return a list of courses that are on the
  # Berkeley schedule, but not on the EECS schedule.
  ee_enroll = parse_enrollment('Electrical+Engineering', term)
  cs_enroll = parse_enrollment('Computer+Science', term)

  errors = []
  (ee_enroll + cs_enroll).each do |course, enrolled|
    if courses.key?(course)
      courses[course].enrollment = enrolled
    else
      errors << "#{course} (#{enrolled} enrolled)"
    end
  end
  errors
end

def parse_enrollment(dept, term)
  # Return array of [:course, enrollment] from all OSOC pages.
  url = OSOC_URL + "?p_term=#{term}&p_deptname=#{dept}"
  row = 1
  pages = []
  while true
    puts "Begging #{url} for page #{row/100}"
    pages << Nokogiri::HTML(open(url + "&p_start_row=#{row}"))
    first_label = pages.last.search('label')[0].text
    first_label == 'see next results' ? row += 100 : break
  end
  pages.map { |page| parse_osoc(page) }.flatten(1)
end

def parse_osoc(osoc_page)
  # Return array of [:course, enrollment] from one OSOC page.
  result = []
  osoc_page.search('table')[1..-2].each do |section|
    cells = section.search('td')
    name = cells[2].text.split
    course = "#{name[0][0]}#{name[1][0]}#{name[2]}-#{name[-2].gsub(/^0*/, '')}"
    units = cells[14].text
    enrollment = cells[-2].text.split[1].delete('Enrolled:')
    if !units.empty? # To avoid discussion/lab sections
      result << [course.downcase.to_sym, enrollment]
    end
  end
  result
end

# Turn the scraped information into a hash of Course objects

class Course
  attr_reader :name, :section, :prof_list, :time, :place
  attr_accessor :ta_list, :enrollment

  def initialize(row)
    @ccn, @name, @section, _, @title, @prof_list, @time, @place = *row
    @ta_list = Set.new
    @enrollment = 'UNKNOWN'

    # for csv formatting
    @prof_list = @prof_list.split('; ')
    @prof_list << '' while @prof_list.size < 2
    @time = @time.gsub(/;/, ',')
  end

  def add_tas(row)
    @ta_list.merge(row[5].split('; '))
  end

  def to_sym
    "#{@name}-#{@section}".delete(' ').downcase.to_sym
  end

  def to_a
    [@name, @section, @enrollment, *@prof_list, @time, @place, *@ta_list]
  end
end

def make_courses(rows)
  # Turn table into hash of {:courses => <Courses>}
  courses = {}
  next_course = []
  rows.each do |row|
    if row.last && !next_course.empty? # this row is main section
      courses.update(make_course(next_course))
      next_course = []
    end
    next_course << row
  end
  courses.update(make_course(next_course)) # don't forget last class
end

def make_course(course_rows)
  # Turn rows for a course into a hash of {:course => <Course>}
  course = Course.new(course_rows.first)
  course_rows.drop(1).each { |row| course.add_tas(row) }
  {course.to_sym => course}
end

def write_course_info(courses, date)
  CSV.open("course_info_#{date}.csv", 'wb') do |csv|
    courses.each { |course| csv << course.to_a }
  end
end

def find_overlap(info, block)
  # Return a map sorting elements of info into buckets, according to block.
  # Only keep buckets with more than one element.
  map = Hash.new { |h, k| h[k] = [] }
  info.each { |elem| map[block[elem]] << elem }
  map.delete_if { |_, v| v.size == 1 }
end

def write_crosslists(courses, date)
  File.open("crosslists_#{date}.txt", 'w') do |file|
    file.puts("The following courses *might* be cross-listed.", "\n")
    courses.select! { |course| course.time != 'UNSCHED' }
    by_times = find_overlap(courses, ->(course) { course.time })
    by_times.each do |time, courses|
      by_prof = find_overlap(courses, ->(course) { course.prof_list.join('; ') })
      by_prof.each do |profs, courses|
        file.puts(time, profs, courses.map { |course| course.name }.join(', '), "\n")
      end
    end
  end
end

def main
  ee, cs = parse_schedule(EE_URL), parse_schedule(CS_URL)
  all_classes = ee.drop(1) + cs.drop(1)
  courses = make_courses(all_classes)
  osoc_errors = update_enrollment(courses)

  date = Time.now.strftime('%Y%m%d')
  head = [%w(Course Sec Enrolled Instructor(1) Instructor(2) Time Place TA's)]
  write_course_info(head + courses.values, date)
  write_crosslists(courses.values, date)
  puts "Written to course_info_#{date}.csv and crosslists_#{date}.txt."

  puts "The following courses may be missing from the csv output:", osoc_errors
end

main
