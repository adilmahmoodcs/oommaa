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

    function showPageChangeConfirmation(this$){
      var dialog = bootbox.dialog({
        title: 'Some changes are un-saved',
        message: "<p>Kindly save or discard changed before switch the page or stay on this page.</p>",
        buttons: {
          cancel: {
              label: "Stay me on this page",
              className: 'btn-default',
              callback: function(){
              }
          },
          discard: {
              label: "Discard changes before move!",
              className: 'btn-danger',
              callback: function(){
                window.location.href = this$.attr('href');
              }
          },
          save: {
              label: "Save changes before move!",
              className: 'btn-primary',
              callback: function(){
                params = this$.attr('href').split('?')[1].split('&');
                cv_val = ''
                $.each(params, function(i, v){

                  if (v.split('=')[0] == 'current_page'){
                    cv_val = v.split('=')[1];
                  }
                });
                $('#current_page').val(cv_val);
                $form.find('#save_form').click();
              }
          }
        }
        });

    }



    $('.change-edit-employee-current-page').click(function(e){
      if ($form.serialize() !== origForm && changedForm == true){
        var this$ = $(this);
        e.preventDefault();
        showPageChangeConfirmation(this$);
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
