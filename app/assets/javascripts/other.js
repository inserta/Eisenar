$(document).ready(function(){
  $("#save_data_contact").click(function(e) {
    var data = {};
    // data["contact_map_phone"] = $(".contact_map_phone").val();
    data["contact_map_sevilla"] = $(".contact_map_sevilla").val();
    data["contact_map_madrid"] = $(".contact_map_madrid").val();
    data["contact_map_interes"] = $(".contact_map_interes").val();
    data["questions_email"] = $(".questions_email").val();
    data["offer_contact"] = $(".offer_contact").val();

    $.ajax({
      type: "POST",
      url: "/save_contacts",
      data: data,
      success: function (data) {
        showToast();
      }
    });
  });
});