#= require jquery
#= require jquery_ujs
#= require jquery-ui/effect
#= require jquery-ui/effect-highlight
#= require jquery-ui/datepicker
#= require jquery-ui/autocomplete
#= require jquery-ui/sortable
#= require jquery-ui/draggable
#= require jquery-fileupload/basic
#= require bootstrap
#= require select2
#= require moment
#= require local_time
#= require bootstrap-datetimepicker
#= require virgo/lib
#= require tinymce/manifest
#= require virgo/common
#= require virgo/admin
#= require virgo/components
#= require virgo/posts
#= require virgo/page_modules
#= require_self

$ ->
  $('.select2-anchor').select2()
  $("[data-toggle='tooltip']").tooltip()

  EllipseFix.run()
  ImageWrapper.run()
  ResponsiveEmbed.run()

  $('#menu-toggle').click (e) ->
    e.preventDefault()
    $('#wrapper').toggleClass('toggled')

  $('a.cancel-events').click (e) -> e.preventDefault()

  $('body').addClass("browser-#{$.browser.name}")
