$(document).ready(function(){
  /////////////////////////////////////////////
  //////////////////Home content///////////////
  /////////////////////////////////////////////
  $(".edit_button_home_content").click(function(e) {
    tr = $(this).closest('.tr_home_content');

    var data = {};
    data["name_id"] = tr.find(".td_name_id").text();
    data["display_name"] = tr.find(".td_display_name").text();
    data["active"] = tr.find(".td_active input").is(":checked");
    data["line_id"] = $(this).data("line_id");

    $.ajax({
      type: "POST",
      url: "/change_home_content_line",
      data: data,
      success: function (data) {
        showToast();
      }
    });
  });
  /////////////////////////////////////////////
});