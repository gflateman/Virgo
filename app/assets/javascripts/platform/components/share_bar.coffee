class ShareBar
  constructor: ->
    $('body').on 'click', '.js-fb-share', @present_fb_share
    $('body').on 'click', '.js-fb-like', @show_fb_like_widget
    @load_fb_share_count()
    @load_tweet_count()

  load_fb_share_count: =>
    info_url = "#{window.location.protocol}//api.facebook.com/method/links.getStats?urls=#{encodeURIComponent(window.page_url)}&format=json&callback=?"

    $.getJSON info_url, (response) =>
      if response and response[0] and response[0].share_count
        share_count = response[0].share_count

        if share_count
          $share_count_tpl = $("<span class='fb-share-count count'>(#{share_count})</span>")
          $(".js-fb-share").each ->
            $share_count = $share_count_tpl.clone()
            $(this).append($share_count)

  load_tweet_count: =>
    info_url = "#{window.location.protocol}//urls.api.twitter.com/1/urls/count.json?url=#{encodeURIComponent(window.page_url)}&callback=?"

    $.getJSON info_url, (response) =>
      if response and response.count
        $tweet_count_tpl = $("<span class='tweet-count count'>(#{response.count})</span>")
        $(".js-tweet-button").each ->
          $tweet_count = $tweet_count_tpl.clone()
          $(this).append($tweet_count)

  present_fb_share: (e) =>
    e.preventDefault()

    $link = $(e.currentTarget)

    FB.ui({
      method: 'share',
      href: $link.attr("data-share-uri")
    })

  show_fb_like_widget: (e) =>
    e.preventDefault()
    $el = $(e.currentTarget)
    $wrap = $el.parents(".share-links-wrap").first()

    $wrap.find(".like-widget-wrap").toggleClass("hidden", 0)


$ -> new ShareBar if $('.share-links').length
