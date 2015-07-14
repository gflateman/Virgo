class PageModuleEditSubjectForm
  constructor: ->
    @init_multiselect()
    @post_select = $('#page-module-subject-select')
    @subject_id_input = $("#page_module_subject_id")
    @clear_link = $(".js-clear-page-module-subject")

    @post_select.autocomplete
      source: (request, response) =>
        $.get "/admin/posts/find", {term: request.term}, (resp) =>
          data = []

          for item in resp.posts
            data.push({label: item.headline, value: item.headline, subject_id: item.id})

          response(data)

      select: (event, ui) =>
        @subject_id_input.val(ui.item.subject_id)

    @clear_link.click (e) =>
      e.preventDefault()
      @post_select.val("")
      @subject_id_input.val("")

  init_multiselect: =>
    $('.js-post-multiselect').multiselect()

window.PageModuleEditSubjectForm = PageModuleEditSubjectForm
