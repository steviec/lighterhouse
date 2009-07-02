// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitDragWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $("#drag_list").sortable('serialize'), null, "script");
    return false;
  })
  return this;
};

$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

$(document).ready(function(){

    $(".ajax_drag").submitDragWithAjax();

    $("#drag_list").sortable({
        placeholder: "ui-selected",
        revert: true,
        connectWith:["#add_list"],
        update : function () {
                $("#drag_list").submit();
        }
    });

    $("#add_list").sortable({ 
        placeholder: "ui-selected",
        revert: true,
        connectWith:["#drag_list"]
    });
})