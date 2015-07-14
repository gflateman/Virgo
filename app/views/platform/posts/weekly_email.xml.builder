cache ['rss', Post.posts.publicly_viewable.order(publish_at: :desc).first, Post.maximum(:updated_at), @site, 'weekly_email'] do
  @posts = Post.posts.for_weekly_email.where("publish_at >= ?", 1.week.ago).order(publish_at: :desc).limit(@limit)
  xml.instruct! :xml, :version => "1.0"
  xml.rss(version: '2.0', "xmlns:media" => "http://search.yahoo.com/mrss") {
    xml.channel {
      xml.title("#{t('site_name')}")
      xml.link(request.host)

      if @site.weekly_newsletter_intro_copy.present?
        xml.description(@site.weekly_newsletter_intro_copy)
      else
        xml.description("Exploring sleep with our eyes wide open")
      end

      @posts.each do |post|
        cache post do
          rss_post(xml, post)
        end
      end
    }
  }
end
