class AdminPostForm
  constructor: ->
    tinyMCE.init({
      selector: '.editor-custom'
      skin: 'railspress'
      inline_styles: false
      apply_source_formatting: false
      height: 640
      plugins: ["image_manager", "link", "wordcount", "code", "paste"]
      object_resizing: false
      menubar: "edit insert format" # tools"
      paste_text_sticky: true
      paste_text_sticky_default: true
      toolbar: "styleselect | bold italic | undo redo | link | image | code "
    })
    $('#publish-at-input').datetimepicker()
    @init_tag_select()
    @bind_events()

  bind_events: =>
    $('body').on 'submit', '#category-form', @submit_category_form
    $('body').on 'click', '#new-category-link', @present_category_form
    $('body').on 'submit', '#tag-form', @submit_tag_form
    $('body').on 'click', '#new-tag-link', @present_tag_form
    $('body').on 'click', '.js-refresh-authors', @refresh_authors
    $('body').on 'submit', '.admin-post-form', @clean_data


    # remove modal from DOM when closed...
    $('body').on 'hidden.bs.modal', '#category-modal', ->
        $(this).data('bs.modal', null)
        $(this).remove()

  init_tag_select: =>
    _val = $.parseJSON($('.tags-select').val())

    $('.tags-select').select2({
      data: @all_tag_objects(),
      multiple: true
    })

    $('.tags-select').select2("val", _val)

    $('.tags-select').select2("container").find("ul.select2-choices").sortable({
      containment: 'parent'
      start: -> $('.tags-select').select2("onSortStart")
      update: -> $('.tags-select').select2("onSortEnd")
    })

  all_tag_names: =>
    Object.keys(window.tag_info)

  selected_tag_names: =>
    ids = $.parseJSON($('.tags-select').val())
    collection = []

    for id in ids
      collection.push(@tag_name(id))

    collection

  tag_name: (tag_id) =>
    invertObject(window.tag_info)[tag_id]

  tag_id: (tag_name) =>
    window.tag_info[tag_name]

  all_tag_objects: =>
    objs = []

    for k,v of invertObject(window.tag_info)
      objs.push(id: k, text: v)

    objs

  submit_category_form: (e) =>
    e.preventDefault()

    $form = $(e.currentTarget)

    $form.find('.js-submit-category').button('loading')

    $.post $form.attr('action'), $form.serialize(), (response) =>
      $(".modal-dialog").replaceWith($(response.html).find('.modal-dialog'))
      $form.find('.js-submit-category').button('reset')

      if response.status == "success"
        $('.post-categories').replaceWith(response.categories_form_partial)

  submit_tag_form: (e) =>
    e.preventDefault()

    $form = $(e.currentTarget)

    $form.find('.js-submit-tag').button('loading')

    $.post $form.attr('action'), $form.serialize(), (response) =>
      $form.find('.js-submit-tag').button('reset')

      $(".modal-dialog").replaceWith($(response.html).find('.modal-dialog'))

      if response.status == "success"
        newTag = response.tag
        window.tag_info[newTag.name] = newTag.id
        vals = $(".tags-select").select2("val")
        vals.push(newTag.id.toString())
        $(".tags-box-loading").show()
        $(".tags-select").select2("destroy")
        $(".tags-select").val("[#{vals.join(',')}]")
        @init_tag_select()
        $(".tags-select").select2("val", vals)
        $(".tags-box-loading").hide()

  present_category_form: (e) =>
    e.preventDefault()

    $link = $(e.currentTarget)

    $.get $link.attr('data-uri'), (response) =>
      if response.status == 'success'
        if $('#category-modal').length
          $('#category-modal').modal('hide').data('bs.modal', null).remove()

        $modal = $(response.html)
        $('body').prepend($modal)
        $modal.modal()

  present_tag_form: (e) =>
    e.preventDefault()

    $link = $(e.currentTarget)

    $.get $link.attr('data-uri'), (response) =>
      if response.status == 'success'
        if $('#tag-modal').length
          $('#tag-modal').modal('hide').data('bs.modal', null).remove()

        $modal = $(response.html)
        $('body').prepend($modal)
        $modal.modal()

  refresh_authors: (e) =>
    e.preventDefault()

    $link = $(e.currentTarget)

    uri = $(".js-author-dropdown").attr("data-refresh-uri")

    $link.find("i").addClass("fa-spin")

    $.get uri, (response) =>
      $link.find("i").removeClass("fa-spin")
      $el = $(response.html)
      $(".js-author-dropdown").replaceWith($el)
      $el.effect('highlight', {}, 1000)

  clean_data: (e) =>
    $input = $("[name='post[body]']")
    $html = $("<div>" + $input.val() + "</div>")

    # remove empty divs and ps
    $html.find("div, p").each ->
      if $(this).html() == ""
        $(this).remove()

    $input.val($html.html())

    tag_ids = $(".tags-select").select2("val")

    tag_val_str = "[#{tag_ids.join(',')}]"

    $(".tags-box-loading").show()

    $(".tags-select").select2("destroy")

    $(".tags-select").val(tag_val_str)

    true

$ ->
  new AdminPostForm if $('.admin-post-form').length
