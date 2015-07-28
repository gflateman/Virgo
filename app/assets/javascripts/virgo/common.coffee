class EllipseFix
  @run: ->
    $("span.ellipse").each ->
      $ellipse = $(this)
      $parent = $(this).parent()
      $parent.addClass("ellipse-wrap")

      $lastP = null

      $(this).parents(".post-body").first().find("p:not(.ellipse-wrap)").each ->
        if $(this).html() != ""
          $lastP = $(this)

      if $lastP
        $lastP.append($ellipse)
        # $parent.remove()

window.EllipseFix = EllipseFix

class ImageWrapper
  @run: ->
    $(".post .post-img").each ->
      $img = $(this)
      $wrapper = $("<div class='image-wrap'></div>")
      $img.wrap($wrapper)
      $wrapper = $img.parents('.image-wrap').first()

      # move the image's style attribute to the wrapper
      if $img.attr("style") and $img.attr("style") != ""
        $wrapper.attr("style", $img.attr("style"))
        $img.removeAttr("style")

      if $img.attr("data-credit") and $img.attr("data-credit") != '' and $img.attr("data-credit") != 'null'
        $credit = $("<div class='image-credit'></div>")
        $credit.html(decodeURIComponent($img.attr("data-credit")))
        $wrapper.append($credit)

      if $img.attr("data-caption") and $img.attr("data-caption") != '' and $img.attr("data-caption") != 'null'
        $caption = $("<div class='image-caption'></div>")
        $caption.html(decodeURIComponent($img.attr("data-caption")))
        $wrapper.append($caption)


window.ImageWrapper = ImageWrapper

class ResponsiveEmbed
  @run: ->
    @convert_videos_to_responsive()

  @convert_videos_to_responsive: =>
    self = this

    $('.responsive-video-wrap').each ->
      $this = $(this)
      $embed = $this.children().first()

      if self.is_recognized_video_embed_url($embed.attr('src'))
        $wrapper = $("<div class='embed-responsive embed-responsive-16by9 video-embed-wrap'></div>")
        $embed.removeAttr("width").removeAttr("height").addClass("embed-responsive-item video-embed")
        $embed.wrap($wrapper)



  @is_recognized_video_embed_url: (url) =>
    provider = url.match(/https?:\/\/(:?www.)?(\w*)/)[2]

    if provider == 'youtube' or provider == 'vimeo' or provider == 'player' or provider == 'youtu.be'
      return true

    false

window.ResponsiveEmbed = ResponsiveEmbed

$.fn.outerHTML = (s) ->
  if s then this.before(s).remove() else jQuery("<p>").append(this.eq(0).clone()).html();

window.invertObject = (obj) ->
  new_obj = {}

  for k,v of obj
    new_obj[v] = k

  new_obj
