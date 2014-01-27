module CoursesurveysHelper
  # rating should be a float that represents the rating out of 1.00
  def rating_bar(rating, url=nil, inverted=nil)
    outer_html_options = { :class => "ratingbar" }
    if inverted
      width = 100-(rating*100).to_int
      margin_left = 100-width
    else
      width = (rating*100).to_int
      margin_left = 0
    end

    color = (width > 75) ?  "#77c265" : (width > 50) ? "#f6e68b" : "#ed8d86"
    inner_html_options = { :class => "subbar", :style => "width: #{width}%; background-color: #{color}; margin-left: 0px;" }

    if url.nil?
      content_tag(:span, outer_html_options) do
        content_tag("span", "", inner_html_options)
      end
    else
      link_to url do
        content_tag(:span, outer_html_options) do
          content_tag("span", "", inner_html_options)
        end
      end
    end
  end
end