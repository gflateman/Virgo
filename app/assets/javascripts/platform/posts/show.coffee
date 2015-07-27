class PostShow
  constructor: ->
    @convert_videos_to_responsive()
    @track()

  convert_videos_to_responsive: =>
    self = this

    $(".post-body iframe").each ->
      $iframe = $(this)

      if self.is_video_embed_url($iframe.attr('src'))
        $wrapper = $("<div class='embed-responsive embed-responsive-16by9 video-embed-wrap'></div>")
        $iframe.removeAttr("width").removeAttr("height").addClass("embed-responsive-item video-embed")
        $iframe.wrap($wrapper)



  is_video_embed_url: (url) =>
    provider = url.match(/https?:\/\/(:?www.)?(\w*)/)[2]

    if provider == 'youtube' or provider == 'vimeo' or provider == 'player' or provider == 'youtu.be'
      return true

    false

  track: =>
    setTimeout ->
      $.get $(".post").attr("data-tracking-uri")
    , 500

window.PostShow = PostShow
