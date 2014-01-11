class IndrelController < ApplicationController

  def why_hkn
    @indrel_officers = Role.current_officers_from_committee 'indrel'
    @officer_count = Role.current_officers.count
  end

  def contact_us
    @indrel_officers = Role.current_officers_from_committee 'indrel'
  end

  def career_fair
  end

  def resume_books
    book = ResumeBook.order("created_at desc").limit(1).last

    @year_counts = {}
    book.details.split(', ').each do |detail|
      a = detail.split(': ')
      @year_counts[a[0]] = a[1]
    end

    @sum = 0
    @year_counts.each do |year, count|
      @sum += count.to_i
    end
  end
end
