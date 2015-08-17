class PostThumbs
  constructor: ->
    @bind_events()

  bind_events: =>
    # $('body').on 'click', '.post-thumb-box', (e) =>
    #   $link = $(e.currentTarget)
    #   window.location = $link.attr('data-post-url')

  # $(window).resize @position_overlays

    # @position_overlays()

    # $('.post-thumb-box').hover (e) =>
    #   @raise_thumb_overlay($(e.currentTarget))
    # , (e) =>
    #   @lower_thumb_overlay($(e.currentTarget))

    # $('.post-thumb-content').css('visibility', 'visible')

  position_overlays: =>
    self = @ # b/c $.fn.each does not pass an "event" arg

    $('.post-thumb-box').each ->
      self.lower_thumb_overlay($(this))

  lower_thumb_overlay: (thumb) =>
    $content = thumb.find('.post-thumb-content')
    $heading = thumb.find('.post-thumb-headline')
    top_offset = thumb.outerHeight() - $heading.outerHeight()
    $content.css('min-height', "#{thumb.height()}px")
    $content.css('top', "#{top_offset}px")
    thumb.removeClass('expanded')

  raise_thumb_overlay: (thumb) =>
    thumb.addClass('expanded')


$ -> new PostThumbs if $('.post-thumb-box').length

class PopularPosts
  constructor: ->
    @bind_events()
    @fetch_content()

  bind_events: =>
    $('body').on 'click', '.popular-posts-tabs a', (e) =>
      e.preventDefault()

      $link = $(e.currentTarget)

      $(".most-popular-posts-loading-overlay").fadeIn(150)

      $.get $link.attr('data-uri'), (response) =>
        $(".most-popular-posts-box").html($(response.html).html())
        $(".most-popular-posts-loading-overlay").fadeOut(150)


    $('body').on 'click', '.popular-more-link, .popular-prev-link', (e) =>
      e.preventDefault()

      $link = $(e.currentTarget)

      if $link.hasClass('last-page')
        return false

      $(".most-popular-posts-loading-overlay").fadeIn(150)

      $.get $link.attr('href'), (response) =>
        $(".most-popular-posts-box").html($(response.html).html())
        $(".most-popular-posts-loading-overlay").fadeOut(150)

  fetch_content: =>
    $box = $(".js-popular-posts-box")

    $.get $box.attr("data-uri"), (response) =>
      $box.html($(response.html).html())



$ -> new PopularPosts if $('.popular-post').length


class LatestPosts
  constructor: ->
    $('body').on 'click', '.js-load-posts', @load_more
    @loading = false

  load_more: (e) =>
      e.preventDefault()
      $btn = $(e.currentTarget)
      $btn.button('loading')

      if !@loading
        @loading = true

        $.get $btn.attr('data-uri'), (response) =>
          $btn.parent().remove()
          $(".latest-posts").append(response.html)
          @loading = false

$ -> new LatestPosts if $('.latest-posts-box').length

class ListSignup
  constructor: ->
    $('body').on 'submit', '#list-signup-form, #header-signup-form, #ouibounce-list-signup-form', @submit

    $('body').on 'hidden.bs.modal', '#subscriber-success-modal', ->
      $(this).data('bs.modal', null)
      $(this).remove()
      $(".email-input").val("")

  submit: (e) =>
    e.preventDefault()

    $form = $(e.currentTarget)
    $wrap = $form.parent()

    $form.find(".sign-up-btn").button('loading')
    $form.find(".email-input").prop('disabled', true)

    $.post $form.attr('action'), {subscriber: {email: $form.find(".email-input").val()}}, (response) =>
      $form.find(".sign-up-btn").button('reset')
      $form.find(".email-input").prop('disabled', false)
      if response.status == 'success'
        $wrap.find(".list-signup-message.info").hide()
        $wrap.find('.list-signup-message.error').hide()
        $wrap.find('.list-signup-message.success').show()
        $wrap.parent().find('.js-ouibounce-footer-button').html("Continue to Site.")

        if $wrap.hasClass("ouibounce-modal-body")
          source = "ouibounce-modal"
        else if $wrap.hasClass("sticky-signup-form")
          source = "header-form"
        else
          source = "footer-form"

        $(document).trigger("ouibounceSignupOccurred")
        $(document).trigger("list_signup_occurred", [{
          email: $wrap.find(".email-input").val(),
          signupSource: source
        }])

      else
        $wrap.find('.list-signup-message.error').html(response.message).show()


$ -> new ListSignup if $('.list-signup').length


class ColumnFocus
  constructor: ->
    $('.column-box').click ->
      window.location = $(this).attr('data-uri')

$ -> new ColumnFocus if $('.column-box').length
