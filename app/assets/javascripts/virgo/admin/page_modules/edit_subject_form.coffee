class PageModuleEditSubjectForm
  constructor: ->
    @init_multiselect()
    @post_select = $('#page-module-subject-select')
    @subject_id_input = $("#page_module_subject_id")
    @clear_link = $(".js-clear-page-module-subject")

    @post_select.autocomplete
      source: (request, response) =>
        $.get @post_select.attr("data-autocomplete-uri"), {term: request.term}, (resp) =>
          data = []

          for item in resp.posts
            data.push({label: item.label, value: item.label, subject_id: item.value})

          response(data)

      select: (event, ui) =>
        @subject_id_input.val(ui.item.subject_id)

    @clear_link.click (e) =>
      e.preventDefault()
      @post_select.val("")
      @subject_id_input.val("")

  init_multiselect: =>
    @post_multiselect = $('.js-post-multiselect')
    @post_multiselect.multiselect({
      searchFunc: @search_posts
    })

  search_posts: (term, callback) =>
    if term != ""
      $.get @post_multiselect.attr("data-autocomplete-uri"), {term: term}, (response) =>
        callback([response.posts])
    else
      callback([null])

window.PageModuleEditSubjectForm = PageModuleEditSubjectForm
