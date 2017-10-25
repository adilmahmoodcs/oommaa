var Forms = {
  init: function() {
    // this.addMoreFields();
    // this.ShowHideFields();
    this.editEmployeeForom();
  },
  editEmployeeForom: function() {
    var $form = $('form#employee-form'),
      origForm = $form.serialize(),
      changedForm = false;

    $form.off('change').on('change', 'input', function(){
      changedForm = true;
    })


  // var currency = '';
  // $('.change-edit-employee-current-page').confirmation({
  //   rootSelector: '.change-edit-employee-current-page',
  //   container: 'body',
  //   title: 'Some changes are un-saved',
  //   onConfirm: function(currency) {
  //     alert('You choosed ' + currency);
  //   },
  //   buttons: [
  //     {
  //       class: 'btn btn-danger',
  //       icon: 'glyphicon glyphicon-usd',
  //       value: 'US Dollar'
  //     },
  //     {
  //       class: 'btn btn-primary',
  //       icon: 'glyphicon glyphicon-euro',
  //       value: 'Euro'
  //     },
  //     {
  //       class: 'btn btn-warning',
  //       icon: 'glyphicon glyphicon-bitcoin',
  //       value: 'Bitcoin'
  //     },
  //     {
  //       class: 'btn btn-default',
  //       icon: 'glyphicon glyphicon-remove',
  //       cancel: true
  //     }
  //   ]
  // });


    $('.change-edit-employee-current-page').click(function(e){
      if ($form.serialize() !== origForm && changedForm == true){
        alert("Kindly save the form changes first!!!");
        e.preventDefault();
      }
    });
  },
  addMoreFields: function() {
    $(".add-another-field").click(function(e) {
      e.preventDefault()
      var last_input = $(this).siblings("input.multiple-field").last()
      last_input.clone().val("").insertAfter(last_input)
    })
  },

  ShowHideFields: function() {
    $('.affiliate_page_name').on('click', '.update_name_btn', function() {
      $(this).removeClass("show").addClass("hide");
      $(this).parent().find("span").addClass("hide");
      $(this).parent().find("form").removeClass("hide");
    });
  }


}
