$(document).ready(function(){
  //////////Contact seguradoras
  $("#seg_add_line").click(function(e) {
    $(".contact_seg_tr:last").clone().appendTo(".seg_table");

    $(".contact_seg_tr:last").find(".preview_td img").attr("src", "");

    $(".contact_seg_tr:last").find(".td_name").text("");

    $(".contact_seg_tr:last").find(".td_phone").text("");

    $(".contact_seg_tr:last").find(".td_email").text("");

    $(".contact_seg_tr:last").find(".contact_seg_edit_button").attr("line_id", "new");
    $(".contact_seg_tr:last").find(".contact_seg_delete_button").attr("line_id", "new");
  })

  $(document).on("click",".contact_seg_edit_button",function() {
    line = $(this).closest('.contact_seg_tr');
    line_id = $(this).attr('line_id');

    var fd = line.find(".td_link input");
    
    var formData = new FormData();
      if(fd[0].files.length == 0){
        formData.append('file', "empty");
      }else{
        formData.append('file', fd[0].files[0]);
      }

    formData.append("name", line.find(".td_name").text());
    formData.append("phone", line.find(".td_phone").text());
    formData.append("email", line.find(".td_email").text());
    formData.append("line_id", line_id);
    // var data = {};
    // data["name"] = line.find(".td_name").text();
    // data["phone"] = line.find(".td_phone").text();
    // data["email"] = line.find(".td_email").text();
    // data["line_id"] = line.find(".contact_seg_edit_button").attr("line_id");

    $.ajax({
      type: "POST",
      url: "/change_contact_seg",
      data: formData,
      processData: false,  // tell jQuery not to process the data
      contentType: false,  // tell jQuery not to set contentType
      success: function (data) {
        if(data["code"] != 400){
          line.find(".contact_seg_edit_button").attr("line_id", data.line_id);
          line.find(".contact_seg_delete_button").attr("line_id", data.line_id);
          showToast();
        }else{
          showToastError();
        }
      }
    });
  });

  $(document).on("click",".contact_seg_delete_button",function() {
    line_id = $(this).attr('line_id');
    line = $(this).closest(".contact_seg_tr");

    if(line_id == "new"){
      line.remove();
    }else{
      var data = {};
      data["line_id"] = line_id;
      
      $.ajax({
        type: "POST",
        url: "/delete_contact_seg",
        data: data,
        success: function (data) {
          if(data["code"] != 400){
            line.remove();
            showToast();
          }else{
            showToastError();
          }
        }
      });
    }
  });
});