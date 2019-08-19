$(document).ready(function(){
  $(document).on("click",".save_cron_execute_1_now",function() {
    $.ajax({
      type: "GET",
      url: "/schedule_daily_execute_now",
      success: function (data) {
        if(data["code"] != 400){
          showToast();
        }else{
          showToastError();
        }
        $('#confirmExecute1').modal('hide');
      }
    });
  });

  $(document).on("click",".save_cron_execute_1",function() {
    form = $(this).closest('.card-body');

    var data = {};
    data["hour"] = form.find(".inputHour option:selected").val();
    data["minute"] = form.find(".inputMinute option:selected").val();
    data["active"] = form.find(".activeExecute1").is(":checked");

    $.ajax({
      type: "POST",
      url: "/schedule_cron_daily",
      data: data,
      success: function (data) {
        if(data["code"] != 400){
          showToast();
        }else{
          showToastError();
        }
      }
    });
  });

  $(document).on("click",".save_cron_execute_2_now",function() {
    $.ajax({
      type: "GET",
      url: "/schedule_import_execute_now",
      success: function (data) {
        if(data["code"] != 400){
          showToast();
        }else{
          showToastError();
        }
        $('#confirmExecute2').modal('hide');
      }
    });
  });

  $(document).on("click",".save_cron_execute_2",function() {
    form = $(this).closest('.card-body');

    var data = {};
    data["hour"] = form.find(".inputHour option:selected").val();
    data["minute"] = form.find(".inputMinute option:selected").val();
    data["active"] = form.find(".activeExecute1").is(":checked");

    $.ajax({
      type: "POST",
      url: "/schedule_cron_import",
      data: data,
      success: function (data) {
        if(data["code"] != 400){
          showToast();
        }else{
          showToastError();
        }
      }
    });
  });
});