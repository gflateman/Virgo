class MediaModal
  constructor: (opts) ->
    @mode = 'normal'

    @image_selected_callback = opts.image_selected_callback
    @image_uploaded_callback = opts.image_uploaded_callback

    @bind_events()

  bind_events: =>
    $(document).bind("showMediaModal", @show_media_modal)

    $('body').on 'change', '.image-radio', @image_radio_click
    $('body').on 'submit', '.js-image-upload-panel', @submit_upload
    $('body').on 'change', '#image-upload-file-field', @file_selected
    $('body').on 'click', '.js-insert-selection', @on_image_selected
    $('body').on 'click', '#browse-files-btn', @browse_files_clicked

    $('body').on 'click', '.js-paginate-link', (e) =>
      e.preventDefault()
      @paginate()

    $('body').on 'click', '.media-modal-nav li a', (e) =>
      e.preventDefault()
      $link = $(e.currentTarget)
      $('.media-modal-nav li.active').removeClass('active')
      $link.parents('li').first().addClass('active')
      @show_loading()
      $.get $link.attr('href'), (response) =>
        $("#media-modal-content-area").html(response.html)
        @init_fileupload()
        @hide_loading()

  show_media_modal: (e) =>
    e.preventDefault() if e?

    if e && e.data && e.data.mode?
      @mode = e.data.mode

    $.get '/admin/media_modal', (response) =>
      if $('#media-modal').length
        $('#media-modal').modal('hide').data('bs.modal', null).remove()

      $modal = $(response.html)
      $('body').prepend($modal)
      $modal.modal()
      @modal_launch_events()

  show_loading: =>
    $('#media-modal-content-area').css({opacity: 0.65})

  hide_loading: =>
    $('#media-modal-content-area').css({opacity: 1})

  modal_launch_events: =>
   $('.media-thumbnails').scroll @on_thumbnails_scroll

  image_radio_click: =>
    $('#insert-selection').removeClass('hidden')

  on_thumbnails_scroll: (e) =>
    if @scroll_distance_from_bottom() < @paginationThreshold
      @paginate()


  paginate: (e) =>
    if $(".paginator").attr('data-last-page') != 'true' && !@paginating
      uri = $(".paginator").attr("data-uri")
      @paginating = true
      @show_loading()

      $.get uri, (response) =>
        $('.media-thumbnails-inner').append($(response.html).find('.media-thumbnails-inner').html())
        $(".paginator").replaceWith($(response.html).find(".paginator"))
        @paginating = false
        @hide_loading()


  update_upload_progress_indicator: (e, data) =>
    percent_loaded = parseInt(data.loaded / data.total * 100, 10)
    $(".upload-progress").show()
    $(".upload-progress .progress-bar").css("width", "#{percent_loaded}%")
    $(".upload-progress .progress-amount").html("#{percent_loaded}%")

    if percent_loaded == 100
      $(".progress-text").html("Processing uploaded image. Please be patient...")

  submit_upload: (e) =>
    e.preventDefault()

    $form = $("form.js-image-upload-panel")

    unless @files
      alert("You must select a file")
      return false

    if $("#image_name").val() == ""
      alert("You must enter a name for this image")
      return false

    if @upload_data
      @upload_data.submit()

    $('#upload-button').button('loading')


  init_fileupload: =>
    $form = $("form.js-image-upload-panel")

    @files = false

    if $form.length
      unless $form.data('blueimpFileupload')
        $form.fileupload(
          progressall: @update_upload_progress_indicator
          dataType: 'json'
          add: (e, data) =>
            @files = true
            @upload_data = data
            $('#browse-files-btn').html('File Added').css('opacity', '0.7')
          done: (e, data) =>
            response = data.result
            $('#upload-button').button('reset')
            $("#media-modal-content-area").html(response.html)
            if response.status == 'upload_success'
              @image_uploaded_callback(response.image, response.image_html)
      )

  on_image_selected: (e) =>
    e.preventDefault()

    $(".js-insert-selection").button("loading")

    $selection = $(".image-radio:checked")

    data = $.parseJSON($selection.attr('data-image'))

    data.selected_el = $(e.currentTarget)

    @image_selected_callback(data)

  file_selected: (e) =>
    @files = e.target.files

  scroll_distance_from_bottom: =>
    distance = $('.media-thumbnails-inner').height() - ($('.media-thumbnails').height() + $('.media-thumbnails').scrollTop())

  browse_files_clicked: (e) =>
    e.preventDefault()

window.MediaModal = MediaModal
