$(document).ready(function(){
  ///////////OFFER
  $("#offer_add_line").click(function(e) {
    $(".offer_add_content:last").clone().appendTo(".offer_table");

    $(".offer_add_content:last").find(".name_td").text("");

    $(".offer_add_content:last").find(".description_td").text("");

    $(".offer_add_content:last").find(".visible_td").find("input").prop("checked", true);

    $(".offer_add_content:last").find(".preview_td img").attr("src", "");

    $(".offer_add_content:last").find(".offer_edit_button").attr("line_id", "new");
    $(".offer_add_content:last").find(".offer_delete_button").attr("line_id", "new");
  })

  $(document).on("click",".offer_edit_button",function() {
    line_id = $(this).attr('line_id');
    line = $(this).closest('.offer_add_content');

    var fd = line.find(".link_td input");

    send = true;
    var formData = new FormData();
    if(fd[0].files[0] && (fd[0].files[0]["type"] == "image/png" || fd[0].files[0]["type"] == "image/jpg" || fd[0].files[0]["type"] == "image/jpeg" || fd[0].files[0]["type"] == "application/pdf")){
      formData.append('file', fd[0].files[0]);
    }else if(fd[0].files[0] && line_id == "new" && (fd[0].files[0]["type"] == "image/png" || fd[0].files[0]["type"] == "image/jpg" || fd[0].files[0]["type"] == "image/jpeg" || fd[0].files[0]["type"] == "application/pdf")){
      formData.append('file', fd[0].files[0]);
    }else if(!fd[0].files[0] && line_id != "new"){
    }else{
      showToastOffer();
      send = false;
    }

    if(send){
      formData.append("name", line.find(".name_td").text());
      formData.append("description", line.find(".description_td").text());
      formData.append("visible", line.find(".visible_td").find("input").is(":checked"));
      formData.append("line_id", line_id);

      $.ajax({
        type: "POST",
        url: "/change_offer_line",
        data: formData,
        processData: false,  // tell jQuery not to process the data
        contentType: false,  // tell jQuery not to set contentType
        success: function (data) {
          if(data["code"] != 400){
            line.find(".offer_edit_button").attr("line_id", data.line_id);
            line.find(".offer_delete_button").attr("line_id", data.line_id);
            showToast();
          }else{
            showToastError();
          }
        }
      });
    }
    
  })

  $(document).on("click",".offer_delete_button",function() {
    line_id = $(this).attr('line_id');
    line = $(this).closest(".offer_add_content");

    if(line_id == "new"){
      line.remove();
    }else{
      var data = {};
      data["line_id"] = line_id;
      
      $.ajax({
        type: "POST",
        url: "/delete_offer_line",
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