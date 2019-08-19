
/////////////////////////////////////////////
/////////////////////////////////////////////
function showToast(){
  $('#showtoast').addClass("show");
  setTimeout(
    function(){
      $('#showtoast').removeClass("show");
    }, 3000);
}

function showToastError(){
  $('#showtoast_error').addClass("show");
  setTimeout(
    function(){
      $('#showtoast_error').removeClass("show");
    }, 3000);
}

function showToastOffer(){
  $('#showtoast_offer').addClass("show");
  setTimeout(
    function(){
      $('#showtoast_offer').removeClass("show");
    }, 3000);
}
/////////////////////////////////////////////
/////////////////////////////////////////////