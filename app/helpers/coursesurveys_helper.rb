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

  def rating_and_bar(score, max, url=nil, inverted=nil, options={})
    if score and !score.to_f.nan? and max and max.to_f != 0
      contents = ['<span class="rating">',
                  sprintf("%.1f", score.round(1)),
                  %Q{</span><span class="rating2"> / #{max}</span>},
                  rating_bar(score/max.to_f, url, inverted)
                 ].join
    else
      contents = ''
    end
 
    content_tag(:span, contents.html_safe)
  end
end