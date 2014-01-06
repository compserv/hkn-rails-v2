module ApplicationHelper

  # This is for the pagination sort links
  # This could probably be cleaned up a bit more...
  def sort_link(inner_text, sort_variable, opts = {})
    sort_direction = 'up'

    @search_opts ||= {}
    @search_opts = {
      'sort'           => params[:sort] || sort_variable,
      'sort_direction' => params[:sort_direction] || 'down'
    }.merge(@search_opts)

    if sort_variable == @search_opts['sort'] and @search_opts['sort_direction'] != 'down'
      sort_direction = 'down'
    end
    arrow = (sort_variable == @search_opts['sort']) ? (@search_opts['sort_direction'] == 'down') ? image_tag('site/arrow_desc.gif') : image_tag('site/arrow_asc.gif') : ''
    link_to(inner_text, @search_opts.merge('sort' => sort_variable, 'sort_direction' => sort_direction)) + arrow
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
            complete: function (xhr, status) { // This is retarded. Because we are asking for a script response and getting an html render response it will throw the error handler and not the success.  Hack solution is to use complete
              if (status === 'error' || !xhr.responseText) {
                // plz give up?
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
      }
    });
  }
})"
  end

  def spinner
    raw '<div id="spinner"><img src="/assets/site/spinner.gif" alt="Loading..."/></div>'
  end
end
