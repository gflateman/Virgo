class Slideshow
  constructor: ->
    self = @

    $('.js-expand-slideshow-box').on 'click', (e) ->
      $wrap = $(this).parents(".slideshow-box-wrapper").first()
      $('body').prepend($wrap)
      $wrap.addClass('expanded')
      $wrap.css("height", "#{$(document).height()}px")
      target_top_offset = $(document).scrollTop() + 25
      $wrap.find(".slideshow-box").css("top", "#{target_top_offset}px")

    $('.js-collapse-slideshow-box').on 'click', (e) ->
      $wrap = $(this).parents(".slideshow-box-wrapper").first()
      $slideshow = $wrap.find(".carousel")
      $anchor = $(".slideshow-box-anchor[data-target='##{$slideshow.attr('id')}']")
      $wrap.css("height", "auto")
      $anchor.append($wrap)
      $wrap.removeClass('expanded')
      $wrap.find(".slideshow-box").css("top", "auto")

    $('.slideshow-box .carousel').on 'slide.bs.carousel', (e) ->
      $slide_info_box = $(this).find('.slide-info')
      slide_idx = $(e.relatedTarget).index() + 1

      if slide_idx > $(this).find(".item").length
        slide_idx = 1

      $slide_info_box.find(".active-slide-num").html(slide_idx)

$ ->
  unless window.slideshows_initialized
    if $('.slideshow-box').length
      new Slideshow if $('.slideshow-box').length
      window.slideshows_initialized = true
