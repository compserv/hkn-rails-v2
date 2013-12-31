class IndrelController < ApplicationController
  def contact_us
    #TODO: Improve once User models are finished. 
    #@indrel_officers = MemberSemester.current.select { |member| member.has_role? :indrel }
  end
end
