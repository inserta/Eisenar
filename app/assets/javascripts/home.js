//= require sb-admin
//= require toast
//= require link
//= require home_content
//= require security
//= require offer
//= require other
//= require client
//= require scheduler

$(document).ready(function(){
  $(".side_menu").click(function(e) {
    $(".side_menu").removeClass("active");
    $(this).addClass("active");
    
    $(".content_area").addClass("hidden");
    $("." + $(this).attr('to_content')).removeClass("hidden");

    $(".breadcrumb_personal").text($(this).attr('title'));
  });

  $(".change_password_from_email").click(function(e) {
    form = $(this).closest(".form_field");
    token = $(this).attr("token");

    var data = {};
    data["email"] = form.find(".email_field").val();
    data["password"] = form.find(".password_field").val();

    button = form.find("button");
    button.attr("disabled", true);

    $.ajax({
      type: "POST",
      url: "/change_user_password/" + token,
      data: data,
      success: function (data) {
        if(data["code"] != 400){
          form.find(".ok").removeClass("hidden");
          setTimeout(function(){
            window.location.replace("http://www.eisenar.com/");
          }, 2000);
        }else{
          form.find(".nok").removeClass("hidden");
          button.attr("disabled", false);
          setTimeout(function(){
            form.find(".nok").addClass("hidden");
          }, 2000);
        }

      }
    });
  });

  $(".enter_admin_user").click(function(e) {
    form = $(this).closest(".form_field");

    var data = {};
    data["username"] = form.find(".username_field").val();
    data["password"] = form.find(".password_field").val();

    button = form.find("button");
    button.attr("disabled", true);

    $.ajax({
      type: "POST",
      url: "/sign_in_admin/",
      data: data,
      success: function (data) {
        if(data["code"] == 400){
          form.find(".nok").removeClass("hidden");
          button.attr("disabled", false);
          setTimeout(function(){
            form.find(".nok").addClass("hidden");
          }, 2000);
        }else{
          window.location.replace("/");
        }

      }
    });
  });

});