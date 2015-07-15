###
plugin.js

Copyright, Moxiecode Systems AB
Released under LGPL License.

License: http://www.tinymce.com/license
Contributing: http://www.tinymce.com/contributing
###

#global tinymce:true

class ImageManager
  constructor: (@editor) ->
    new window.MediaModal({
      image_uploaded_callback: @on_image_uploaded,
      image_selected_callback: @on_image_selected
    })

    @bind_events()

    @editor.addButton "image",
      icon: "image"
      tooltip: "Insert/edit image"
      onclick: =>
        @media_modal_mode = 'normal'
        @show_dialog()
      stateSelector: "img:not([data-mce-object],[data-mce-placeholder])"

    @editor.addMenuItem "image",
      icon: "image"
      text: "Insert/edit image"
      onclick: =>
        @media_modal_mode = 'normal'
        @show_dialog()
      context: "insert"
      prependToContext: true


  bind_events: =>
    @editor.addCommand "mceImage", @show_dialog
    @editor.on 'dblclick', @on_editor_click

    $('body').on 'submit', '.image-settings-form', @submit_image_settings_modal
    $('body').on 'click', '.js-remove-featured-image', @remove_featured_image
    $('body').on 'click', '.js-remove-thumbnail-image', @remove_thumbnail_image

    $('body').on 'click', '.js-launch-media-modal', (e) =>
      @media_modal_mode = 'normal'
      @show_dialog(e)

    $('body').on 'click', '.js-select-featured-image', (e) =>
      e.preventDefault()
      @media_modal_mode = 'featured_image'
      @show_dialog(e)

    $('body').on 'click', '.js-select-thumbnail-image', (e) =>
      e.preventDefault()
      @media_modal_mode = 'thumbnail_image'
      @show_dialog(e)

    $('body').on 'hidden.bs.modal', '#media-modal, #image-settings-modal', ->
        $(this).data('bs.modal', null)
        $(this).remove()

    $('body').on 'click', '.paginator.last-page', (e) =>
      e.preventDefault()
      e.stopPropagation()

  show_dialog: (e) =>
    $(document).trigger("showMediaModal", {mode: @media_modal_mode})

  present_image_settings_modal: (el) =>
    img_id = el.attr('data-id')
    caption = encodeURIComponent(el.attr("data-caption") || "")

    $.get "/admin/media_modal/image_settings/#{img_id}", {caption: caption}, (response) =>
      if $('#image-settings-modal').length
        $('#image-settings-modal').modal('hide').data('bs.modal', null).remove()

      $modal = $(response.html)
      $('body').prepend($modal)
      $modal.modal()

  remove_featured_image: (e) =>
    e.preventDefault()

    $link = $(e.currentTarget)

    if confirm "Are you sure you would like to remove the featured image from this post (note: removing the featured image from the post will not remove the image from the media library)."
      if $link.attr('href') != '#' # '#' indicates post is not yet persisted
        $.ajax
          type: 'DELETE'
          url: $link.attr('href')

      $("input[name='post[featured_image_id]']").val("")
      $(".featured-image-thumbnail").html("<span class='text-muted empty'>No image selected</span>")
      alert("Featured image successfully removed")

  remove_thumbnail_image: (e) =>
    e.preventDefault()

    $link = $(e.currentTarget)

    if confirm "Are you sure you would like to remove the thumbnail image from this post (note: removing the thumbnail image from the post will not remove the image from the media library)."
      if $link.attr('href') != '#' # '#' indicates post is not yet persisted
        $.ajax
          type: 'DELETE'
          url: $link.attr('href')

      $("input[name='post[thumbnail_image_id]']").val("")
      $(".thumbnail-image-thumbnail").html("<span class='text-muted empty'>No image selected</span>")
      alert("Thumbnail image successfully removed")

  get_image_html: (url, callback) =>
    $.get url, (response) =>
      callback(response.html)

  on_editor_click: (e) =>
    if $(e.target).hasClass('post-img')
      $img = $(e.target)
      @present_image_settings_modal($img)

    true

  submit_image_settings_modal: (e) =>
    e.preventDefault()

    $form = $(e.currentTarget)

    $.ajax
      type: 'PATCH'
      url: $form.attr('action')
      data: $form.serialize()

      success: (response) =>
        if response.status == 'success'
          img = $(@editor.selection.getNode())
          img.attr('alt', response.image.alt_text)
          if response.caption and response.caption != ''
            img.attr('data-caption', encodeURIComponent(response.caption))
          if response.image.credit and response.image.credit != ''
            img.attr('data-credit', encodeURIComponent(response.image.credit))
          $('#image-settings-modal .close').click()
        else
          $(".image-settings-form").html($(response.html).find('.image-settings-form').html())


  on_image_uploaded: (image, image_html) =>
    if @media_modal_mode == 'normal'
      # img_tag = response.image_html
      data = image

      image_attrs =
        src: data.content_image
        alt: data.alt_text
        class: 'post-img'
        'data-id': data.id
        'data-credit': data.credit

      @editor.undoManager.transact =>
        image_attrs.id = "__mcenew"
        @editor.focus()
        @editor.selection.setContent @editor.dom.createHTML("img", image_attrs)
        img_elem = @editor.dom.get("__mcenew")
        @editor.dom.setAttrib img_elem, "id", null

        if @editor.selection
          @editor.selection.select img_elem
          @editor.nodeChanged()
    else if @media_modal_mode == 'thumbnail_image'
      $input = $("input[name='post[thumbnail_image_id]']")
      $input.val(image.id)
      img_tag = $(image_html)
      $(".js-save-thumbnail-image").removeClass('hidden')
      $(".js-no-thumbnail-image-message").addClass("hidden")
      $(".thumbnail-image-thumbnail").html(img_tag.find('img').outerHTML())
      $("#media-modal .close").click()
    else
      $input = $("input[name='post[thumbnail_image_id]']")
      $input.val(image.id)
      img_tag = $(image_html)
      $(".js-save-featured-image").removeClass('hidden')
      $(".js-no-featured-image-message").addClass("hidden")
      $(".featured-image-thumbnail").html(img_tag.find('img').outerHTML())
      $("#media-modal .close").click()

  on_image_selected: (data) =>
    if @media_modal_mode == 'normal'
      image_attrs =
        src: data.content_image
        alt: data.alt_text
        class: 'post-img'
        'data-id': data.id

      if data.credit? and data.credit != '' and data.credit != 'null'
        image_attrs['data-credit'] = encodeURIComponent(data.credit)

      if data.caption? and data.caption != '' and data.caption != 'null'
        image_attrs['data-caption'] = encodeURIComponent(data.caption)

      @editor.undoManager.transact =>
        image_attrs.id = "__mcenew"
        @editor.focus()
        @editor.selection.setContent @editor.dom.createHTML("img", image_attrs)
        img_elem = @editor.dom.get("__mcenew")
        @editor.dom.setAttrib img_elem, "id", null

        if @editor.selection
          @editor.selection.select img_elem
          @editor.nodeChanged()

      $('.media-modal-dialog .close').click()

    else if @media_modal_mode == 'thumbnail_image'
      $input = $("input[name='post[thumbnail_image_id]']")
      $input.val(data.id)

      $(".js-save-thumbnail-image").removeClass('hidden')
      $(".js-no-thumbnail-image-message").addClass("hidden")
      $(".thumbnail-image-thumbnail").removeClass("hidden").find("img").attr("src", data.med_thumb_image)
      $("#media-modal .close").click()
    else
      $input = $("input[name='post[featured_image_id]']")
      $input.val(data.id)

      $(".js-save-featured-image").removeClass('hidden')
      $(".js-no-featured-image-message").addClass("hidden")
      $(".featured-image-thumbnail").removeClass("hidden").find("img").attr("src", data.med_thumb_image)
      $("#media-modal .close").click()


tinymce.PluginManager.add "image_manager", (editor) ->
  new ImageManager(editor)
