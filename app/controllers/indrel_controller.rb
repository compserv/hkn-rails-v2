class IndrelController < ApplicationController
  def contact_us
    @indrel_officers = MemberSemester.current.users.select { |member| member.has_role? :indrel }
  end
end
