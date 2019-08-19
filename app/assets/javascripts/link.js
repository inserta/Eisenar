$(document).ready(function(){
  /////////////////////////////////////////////
  //////////////////    LINKS   ///////////////
  /////////////////////////////////////////////
  $("#link_add_line").click(function(e) {
    $(".link_add_content:last").clone().appendTo(".link_table");

    $(".link_add_content:last").find(".name_td").text("");

    $(".link_add_content:last").find(".url_td").text("");

    $(".link_add_content:last").find(".link_edit_button").attr("line_id", "new");
    $(".link_add_content:last").find(".link_delete_button").attr("line_id", "new");
  })

  $(document).on("click",".link_edit_button",function() {
    tr = $(this).closest('.link_add_content');

    var data = {};
    data["name"] = tr.find(".name_td").text();
    data["url"] = tr.find(".url_td").text();
    data["line_id"] = $(this).attr("line_id");

    $.ajax({
      type: "POST",
      url: "/change_link_line",
      data: data,
      success: function (data) {
        if(data["code"] != 400){
          tr.find(".link_edit_button").attr("line_id", data.id);
          tr.find(".link_delete_button").attr("line_id", data.id);
          showToast();
        }else{
          showToastError();
        }
      }
    });
  })

  $(document).on("click",".link_delete_button",function() {
    id = $(this).attr('line_id');
    line = $(this);

    if(id == "new"){
      $(this).closest(".link_add_content").remove();
    }else{
      var data = {};
      data["line_id"] = id;
      
      $.ajax({
        type: "POST",
        url: "/delete_link_line",
        data: data,
        success: function (data) {
          if(data["code"] != 400){
            line.closest(".link_add_content").remove();
            showToast();
          }else{
            showToastError();
          }
        }
      });
    }
  });
  /////////////////////////////////////////////
  /////////////////////////////////////////////
});