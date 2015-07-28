module Virgo
  module VideoHelper
    def video_provider(video_url='')
      if video_url.include?('vimeo')
        :vimeo
      else
        :youtube
      end
    end

    def youtube_embed_url(youtube_url)
      if youtube_url[/youtu\.be\/([^\?]*)/]
        youtube_id = $1
      else
        # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
        youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
        youtube_id = $5
      end
      "http://www.youtube.com/embed/#{youtube_id}"
    end

    def vimeo_embed_url(video_url)
      vimeo_regex = /https?:\/\/(www\.)?vimeo.com\/(\d+)/

      result = video_url.match(vimeo_regex)

      video_id = result ? result[2] : nil

      if video_id
        "https://player.vimeo.com/video/#{video_id}"
      end
    end
  end
end
