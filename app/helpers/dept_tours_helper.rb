module DeptToursHelper
  def get_default_response_text(dept_tour_request)
"Hello #{dept_tour_request.name},

This email is a confirmation of your requested department tour on #{dept_tour_request.date.strftime("%A, %B %d, at %I:%M %p")}.

Please meet me, or one of our other officers, at 345 Soda Hall at that time.

Looking forward to seeing you!

--#{current_user.full_name}
"
  end
end