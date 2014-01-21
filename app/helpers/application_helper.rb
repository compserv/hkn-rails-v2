module ApplicationHelper
  # http://unixmonkey.net/?p=20
  # HTML encodes ASCII chars a-z, useful for obfuscating
  # an email address from spiders and spammers
  def html_obfuscate(string)
    output_array = []
    lower = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    upper = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
    char_array = string.split('')
    char_array.each do |char|
      output = lower.index(char) + 97 if lower.include?(char)
      output = upper.index(char) + 65 if upper.include?(char)
      if output
        output_array << "&##{output};"
      else
        output_array << char
      end
    end
    return output_array.join
  end

  # This is for the pagination sort links
  def sort_link(inner_text, sort_variable, opts = {})
    sort_direction = (sort_variable == @search_opts['sort'] and @search_opts['sort_direction'] != 'down') ? 'down' : 'up'
    arrow = (sort_variable == @search_opts['sort']) ? (@search_opts['sort_direction'] == 'down') ? image_tag('site/arrow_desc.gif') : image_tag('site/arrow_asc.gif') : ''
    link_to(inner_text, @search_opts.merge('sort' => sort_variable, 'sort_direction' => sort_direction).merge(opts)) + arrow
  end

  # http://wiki.github.com/mislav/will_paginate/ajax-pagination
  # http://brandonaaron.net/blog/2009/02/24/jquery-rails-and-ajax
  # Embedding this in a view will automatically make links which are descendants
  # of an element with the class 'class_name' into AJAX links
  # Note: You need to have an element with the id "spinner" for for spinner
  # graphic. If you don't, then the script will error out and won't perform an
  # AJAX request.
  def ajaxify_links(class_name='ajax-controls')
    javascript_tag \
"$(document).ready( function() {
  var History = window.History;
  var container = $(document.body)

  if (container) {
    container.click( function(e) {
      var el = e.target
      if ($(el).is('.#{class_name} a')) {
        $('#spinner').show();
        if (History.enabled) {
          History.pushState(null, '', el.href);
        } else {
          $.ajax({
            url: el.href,
            method: 'get',
            dataType: 'script',
            complete: function (xhr, status) { // Because we are asking for a script response and getting an html render response it will throw the error handler and not the success.  Hack solution is to use complete
              if (status === 'error' || !xhr.responseText) {
                // just give up?
              }
              else {
                $('#ajax-wrapper').html(xhr.responseText);
              }
            }
          });
        }
        e.preventDefault();
      }
    })
  }
})

$(window).bind('statechange', function(){
  var History = window.History;
  if (History.enabled) {
    var rootUrl = History.getRootUrl();
    var state = History.getState();
    var url = state.url;
    var relativeUrl = url.replace(rootUrl, '');
    $('#spinner').show();
    $.ajax({
      url: url,
      method: 'get',
      //dataType: 'script',
      success: function(data) {
        window.alert('hi');
        var newContent = $(data).find('#ajax-wrapper');
        $('#ajax-wrapper').html(newContent);
      },
      complete: function (xhr, status) {
        window.alert('hi');
        if (status === 'error' || !xhr.responseText) {
          // plz give up?
        }
        else {
        }
      }
    });
  }
})"
  end

  def spinner
    raw '<div id="spinner"><img src="/assets/site/spinner.gif" alt="Loading..."/></div>'
  end

  # Removes the badness from a query, by allowing only common chars.
  # For example, you could break a query by searching for ".
  #
  def sanitize_query(q)
    return '' if q.nil?
    q.gsub(/\s+/, ' ').gsub(/[^a-zA-Z 0-9\*\?'\"]/i, '?')
  end

end

class Array
# This borks activerecord's average
  def avg
    return nil if self.empty?
    self.sum.to_f / self.count.to_f
  end

  def to_ul(tag='ul')
    # Converts a nested array to <ul>
    ["<#{tag}>",
     self.collect do |e| 
        case
        when e.is_a?(Array)
          e.to_ul tag
        else
          "<li>#{e.inspect.semi_escape}</li>"
        end 
     end.join,
     "</#{tag}>"
    ].join
  end
end

class String

  def is_int?
    !self.blank? && self.to_i.to_s.eql?(self)
  end
  
  def semi_escape
    m = { '<' => '&lt;',
          '>' => '&gt;',
          /^\"|\"$/ => '',
          '\\"' => '"'
        }
    s = self.dup
    m.each_pair {|old,new| s.gsub! old, new }
    s
  end

  def to_ul
    [self].to_ul
  end
  
end