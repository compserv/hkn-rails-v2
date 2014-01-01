class IndrelController < ApplicationController
  def why_hkn
    @indrel_officers = Role.current_officers_from_committee 'indrel'
    #Don't we have the same number of officers every semester?
    @officer_count = Role.current_officers.count
  end

  def contact_us
    @indrel_officers = Role.current_officers_from_committee 'indrel'
  end

  def infosessions
  end

  def career_fair
  end

  def resume_books
    #TODO: ResumeBook model
    
    book = ResumeBook.select("cutoff_date, created_at")
                     .order("created_at desc")
                     .limit(1)
                     .last

    cutoff = book.cutoff_date
    creation = book.created_at
    #year = Property.semester[0..3].to_i

    @year_counts = Resume.select("graduation_year")
      .where("updated_at > :cutoff
              AND updated_at < :creation
              AND graduation_year >= :year",
              { :cutoff => cutoff, :year => year, :creation => creation })
      .reorder("graduation_year desc")
      .group("graduation_year")
      .count

    @grad_counts = Resume.select("graduation_year")
      .where("updated_at > :cutoff
              AND updated_at < :creation
              AND graduation_year < :year",
              { :cutoff => cutoff, :year => year, :creation => creation })
      .count

    @sum = 0
    @year_counts.each do |year, count|
      @sum += count
    end

    @sum += @grad_counts
  end
end
