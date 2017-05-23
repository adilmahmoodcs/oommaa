ready = ->
  $('.ckeditor').each ->
  CKEDITOR.replace $(this).attr('id')
