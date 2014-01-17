#!/usr/bin/env ruby

# This script constructs a csv for scheduling course surveys from the EECS
# schedule.
#  + http://www.eecs.berkeley.edu/Scheduling/EE/schedule.html
#  + http://www.eecs.berkeley.edu/Scheduling/CS/schedule.html
#
# In theory, this could break at any time, but it's probably okay since the dept
# auto-generates those schedule pages.
#  - brian

require 'nokogiri'
require 'open-uri'
require 'csv'
require 'set'

EE_URL = 'http://www.eecs.berkeley.edu/Scheduling/EE/schedule.html'
CS_URL = 'http://www.eecs.berkeley.edu/Scheduling/CS/schedule.html'

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

# Turn the scraped information into a hash of Course objects

class Course
  attr_reader :name, :section, :prof_list, :time, :place
  attr_accessor :ta_list

  def initialize(row)
    @ccn, @name, @section, _, @title, @prof_list, @time, @place, @units = *row
    @ta_list = Set.new
    @enrollment = '-' # TODO: scrape this from schedule

    # for csv formatting
    @prof_list = @prof_list.split('; ')
    @prof_list << '' while @prof_list.size < 2
    @time = @time.gsub(/;/, ',')
  end

  def add_tas(row)
    @ta_list.merge(row[5].split('; '))
  end

  def to_sym
    name = @section == 1 ? @name : "#{@name}-#{@section}"
    name.delete(' ').downcase.to_sym
  end

  def to_a
    [@name, @section, @enrollment, *@prof_list, @time, @place, @units, *@ta_list]
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
  courses
end

def make_course(course_rows)
  # Turn rows for a course into a hash of {:course => <Course>}
  course = Course.new(course_rows.first)
  course_rows.drop(1).each { |row| course.add_tas(row) }
  {course.to_sym => course}
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

def write_course_info(courses, date)
  CSV.open("course_info_#{date}.csv", 'wb') do |csv|
    courses.each { |course| csv << course.to_a }
  end
end

def main
  ee, cs = parse_schedule(EE_URL), parse_schedule(CS_URL)
  all_classes = ee.drop(1) + cs.drop(1)
  courses = make_courses(all_classes)

  date = Time.now.strftime('%Y%m%d')
  head = [%w(Course Sec Enrolled Instructor(1) Instructor(2) Time Place units TA's)]
  write_course_info(head + courses.values, date)
  write_crosslists(courses.values, date)

  puts "Written to course_info_#{date}.csv and crosslists_#{date}.txt."
end

main
