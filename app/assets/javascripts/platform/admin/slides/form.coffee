class AdminSlideForm
  constructor: ->
    new window.MediaModal(
      image_selected_callback: @on_image_selected,
      image_uploaded_callback: @on_image_uploaded
    )

    @bind_events()

  bind_events: ->
    $('.js-change-image-link, .js-add-image-link').click (e) =>
      e.preventDefault()
      $(document).trigger("showMediaModal")

  on_image_selected: (data) =>
    $(".js-image-id").val(data.id)
    $(".js-image-thumb").attr("src", data.image_url).removeClass("hidden")
    $(".slide-thumb").removeClass("empty")
    $("#media-modal .close").click()

  on_image_uploaded: (image, image_html) =>
    $(".js-image-id").val(image.id)
    $(".js-image-thumb").attr("src", image.image_url).removeClass("hidden")
    $(".slide-thumb").removeClass("empty")


window.AdminSlideForm = AdminSlideForm
