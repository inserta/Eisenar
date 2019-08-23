$(document).ready(function() {
  
  var table = $('#client_table_datatable').DataTable( {
      "processing": true,
      "serverSide": true,
      "searchable": false,
      "aaSorting": [],
      "ajax": {
        "url": "data_to_datatable",
        "type": "POST"
      },
      "language": {
        "lengthMenu": "Mostrar _MENU_ registros por página",
        "zeroRecords": "Nada encontrado - lo siento",
        "info": "Mostrando la página _PAGE_ de _PAGES_",
        "infoEmpty": "No hay registros disponibles",
        "infoFiltered": "(filtrado de _MAX_ registros totales)",
        "search": "Buscar por DNI:",
        "loadingRecords": "Cargar...",
        "processing":     "Procesamiento...",
        "paginate": {
          "first":      "Primero",
          "last":       "Última",
          "next":       "Siguiente",
          "previous":   "Anterior"
        },
      },
      "columns": [ 
          { 
            "data": "name",
            "bSortable": true
          },
          { 
            "data": "dni",
            "bSortable": true
          },
          { 
            "data": "phone",
            "bSortable": false
          },
          {
            "data": "email",
            "bSortable": false
          },
          { 
            "data": "address",
            "bSortable": false
          },
          { 
            "data": null,
            "bSortable": false
          }
      ],
      "columnDefs": [
        {
          "targets": -1,
          "data": null,
          "defaultContent": '<button class="client_edit btn btn-warning btn-rounded btn-sm my-0" type="button" data-toggle="modal" data-target="#client_modal">Editar</button> <button class="client_delete btn btn-danger btn-rounded btn-sm my-0" type="button">Eliminar</button>'
      } ]
  } );

  $(document).on("click",".client_edit",function() {
    var data = table.row( $(this).parents('tr') ).data();
    modal = $('#client_modal');
    modal.find(".client_name").val(data["name"]);
    modal.find(".client_dni").val(data["dni"]);
    modal.find(".client_phone").val(data["phone"]);
    modal.find(".client_email").val(data["email"]);
    modal.find(".client_address").val(data["address"]);
    addPolicyData(data);
  } );

  /// New client
  $('.client_new').click(function (e) {
    item = {policy: []}
    cleanFields();
    addPolicyData(item);
  })

  function addPolicyData(data){
    $(".policy_block_blank:not(.hidden)").remove();

    policy_data = data["policy"];
    for (i = 0; i < policy_data.length; i++) {
      $(".policy_block_blank:first").find(".sub_type_select").addClass("hidden");
      $(".policy_block_blank:first").find(".matricula.extra_field .extra_field_select").removeClass("hidden");

      if (jQuery.isEmptyObject(policy_data[i])) {
        $(".policy_block_blank:first").removeClass('hidden');
        $(".policy_block_blank:first").clone().insertAfter(".policy_block_blank:last");
        $(".policy_block_blank:first").addClass('hidden');
      }else{
        $(".policy_block_blank:first").removeClass('hidden');

        $(".policy_block_blank:first").find(".client_active").prop('checked', policy_data[i]["active"]);
        $(".policy_block_blank:first").find(".company_select option[value=" +  policy_data[i]["company"] + "]").attr('selected','selected');
        $(".policy_block_blank:first").find(".type_select option[value=" +  policy_data[i]["type"] + "]").attr('selected','selected');

        console.log(policy_data[i]["auto_type"]);
        if(policy_data[i]["auto_type"] != undefined && policy_data[i]["auto_type"] != "none"){
          console.log("with subtype");
          $(".policy_block_blank:first").find(".auto_type_select option[value=" +  policy_data[i]["auto_type"] + "]").attr('selected','selected');
          $(".policy_block_blank:first").find(".matricula.sub_type").removeClass("hidden");

          // if(policy_data[i]["type"] == "auto"){
          console.log(policy_data[i]["type"]);
          // }
          
          $(".policy_block_blank:first").find(".sub_type_select.type_" + policy_data[i]["type"]).removeClass("hidden");
        }

        // Field Extra
        console.log(policy_data[i]["matricula"]);
        if(policy_data[i]["matricula"] != undefined && policy_data[i]["matricula"] != "none"){
          $(".policy_block_blank:first").find(".matricula input").val(policy_data[i]["matricula"]);
          $(".policy_block_blank:first").find(".matricula.extra_field").removeClass("hidden");
          $(".policy_block_blank:first").find(".matricula.extra_field .extra_field_select:not(.type_" + policy_data[i]["type"] + ")").addClass("hidden");
        }


        $(".policy_block_blank:first").find(".file").removeClass("hidden");
        if(policy_data[i]["file_info"] && policy_data[i]["file_info"] != ""){
          $(".policy_block_blank:first").find(".file a").attr("href", policy_data[i]["file_info"]);
          $(".policy_block_blank:first").find(".file a").text("PDF Document");
        }

        $(".policy_block_blank:first").clone().insertAfter(".policy_block_blank:last");

        $(".policy_block_blank:first").addClass('hidden');

        $(".policy_block_blank:first").find(".client_active").prop('checked', true);
        $(".policy_block_blank:first").find(".company_select option[value=" +  policy_data[i]["company"] + "]").attr('selected', false);
        $(".policy_block_blank:first").find(".type_select option[value=" +  policy_data[i]["type"] + "]").attr('selected', false);
        $(".policy_block_blank:first").find(".auto_type_select option[value=" +  policy_data[i]["auto_type"] + "]").attr('selected', false);
        $(".policy_block_blank:first").find(".matricula input").val("");
        $(".policy_block_blank:first").find(".matricula").addClass("hidden");
        $(".policy_block_blank:first").find(".file").addClass("hidden");
        $(".policy_block_blank:first").find(".file a").attr("href", "");
        $(".policy_block_blank:first").find(".file a").text("");
      }
    }
  }

  /// Save new cliente or update
  $('#client_modal .save').click(function (e) {
    e.preventDefault();
    // data = {};
    modal = $('#client_modal');

    var formData = new FormData();
    formData.append("name", modal.find(".client_name").val());
    formData.append("dni", modal.find(".client_dni").val());
    formData.append("phone", modal.find(".client_phone").val());
    formData.append("email", modal.find(".client_email").val());
    formData.append("address", modal.find(".client_address").val());

    policis = []
    policy = {};
    modal.find(".policy_block_blank:not(.hidden)").each(function( index ) {
      policy["company"] = $(this).find(".company_select option:selected").val();
      policy["company_text"] = $(this).find(".company_select option:selected").text();
      policy["type"] = $(this).find(".type_select option:selected").val();
      policy["type_text"] = $(this).find(".type_select option:selected").text();
      policy["auto_type"] = $(this).find(".auto_type_select.type_" + policy["type"] + " option:selected").val();
      policy["auto_type_text"] = $(this).find(".auto_type_select.type_" + policy["type"] + " option:selected").text();
      policy["matricula"] = $(this).find(".matricula input:visible").val();
      policy["active"] = $(this).find(".client_active").prop('checked');

      //FILE
      var fd = $(this).find(".file input");
      var file;
      if(fd[0] && fd[0].files[0]){
        file = fd[0].files[0];
      }else{
        file = false;
        policy["file_info"] = $(this).find(".file a").attr("href");
      }
      
      if(policy["company"] != "none" && policy["type"] != "none"){
        policis.push(policy);
        formData.append("file[]", file);
      }
      policy = {};
      
    });
    
    // data["policy"] = policis;
    formData.append("policy", JSON.stringify(policis));
    
    $.ajax({
      type: "POST",
      url: "/new_user_from_be",
      data: formData,
      processData: false,  // tell jQuery not to process the data
      contentType: false,  // tell jQuery not to set contentType
      success: function (data) {
        if(data["code"] != 400){
          showToast();
          cleanFields();
          $('#client_modal').modal('hide');
          table.ajax.reload();
        }else{
          showToastError();
        }
      }
    });
    return false;
  })

  $('.add_poliza').click(function (e) {
    $(".policy_block_blank:first").removeClass('hidden');
    $(".policy_block_blank:first").clone().insertAfter(".policy_block_blank:last");
    $(".policy_block_blank:first").addClass('hidden');
  })

  $(document).on("click",".remove_poliza",function() {
    $(this).closest(".policy_block_blank").remove();
  })

  // Delete client
  $(document).on("click",".client_delete",function() {
    data = {}
    data["dni"] = table.row( $(this).parents('tr') ).data()["dni"];
    $.ajax({
      type: "POST",
      url: "/delete_user_from_be",
      data: data,
      success: function (data) {
        if(data["code"] != 400){
          showToast();
          table.ajax.reload();
        }else{
          showToastError();
        }
      }
    });
  })
  
  $(document).on("change","select.type_select",function() {
    $(this).closest(".policy_block_blank").find(".file").removeClass("hidden");
    $(this).closest(".policy_block_blank").find(".matricula").addClass("hidden");
    $(this).closest(".policy_block_blank").find(".sub_type_select").addClass("hidden");
    $(this).closest(".policy_block_blank").find(".matricula.extra_field .extra_field_select").removeClass("hidden");

    if($(this).closest(".policy_block_blank").find(".sub_type_select.type_" + this.value).length != 0){
      $(this).closest(".policy_block_blank").find(".sub_type_select.type_" + this.value).removeClass("hidden");
      $(this).closest(".policy_block_blank").find(".matricula.sub_type").removeClass("hidden");
      let type = $(this).find("option[value=" + this.value + "]").attr("text");
      // $(this).closest(".policy_block_blank").find(".matricula label.label_subtype").text(type + " tipo");

    }
    if($(this).closest(".policy_block_blank").find(".client_matricula.extra_field_select.type_" + this.value).length != 0){
      $(this).closest(".policy_block_blank").find(".matricula.extra_field").removeClass("hidden");
      $(this).closest(".policy_block_blank").find(".matricula.extra_field .extra_field_select:not(.type_" + this.value + ")").addClass("hidden");
    }
    
    
    
    // if(this.value == "auto"){
    //   $(this).closest(".policy_block_blank").find(".matricula").removeClass("hidden");
    //   $(this).closest(".policy_block_blank").find(".file").removeClass("hidden");
    // }else{
    //   $(this).closest(".policy_block_blank").find(".matricula").addClass("hidden");
    //   $(this).closest(".policy_block_blank").find(".file").removeClass("hidden");
    // }
  })

  function cleanFields(){
    modal = $('#client_modal');
    modal.find(".client_name").val("");
    modal.find(".client_dni").val("");
    modal.find(".client_phone").val("");
    modal.find(".client_email").val("");
    modal.find(".client_address").val("");
  }

});