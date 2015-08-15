class Header
  constructor: ->
    $(document).on 'hidden', '#signup-modal', ->
      $(this).remove()

    $('.js-expand-search-form').on 'click', (e) ->
      e.preventDefault()
      $('.js-search-form').addClass('expanded').find('#post_search_term').focus()
    $('.js-collapse-search-form').on 'click', ->
      $('.js-search-form').removeClass('expanded')
    $('.close-sticky-signup').on 'click', ->
      $('.sticky-signup-form, .navbar-spacer.large').slideUp(200)
      localStorage.setItem("emailPromptHidden", "true") if window.localStorage?

    $('.js-signup-link').click (e) ->
      e.preventDefault()
      $.get "/subscribers/modal", (response) ->
        # remove existing
        $('#signup-modal').modal('hide') if $('#signup-modal').length

        $modal = $(response.html)

        $modal.modal()

    $(document).on 'submit', '.js-list-signup-form', (e) ->
      e.preventDefault()

      $form = $(e.currentTarget)

      $form.find(".js-submit-btn").button("loading")

      $.ajax
        type: 'POST'
        url: $form.attr('action')
        data: $form.serialize()
        success: (response) =>
          $("#signup-modal .modal-dialog").replaceWith($(response.html).find(".modal-dialog"))


    unless (window.localStorage? && window.localStorage.getItem("emailPromptHidden") == "true")
      $(".sticky-signup-form, .navbar-spacer.large").removeClass('hidden')

$ ->
  unless window.header_initialized
    new Header
    window.header_initialized = true
