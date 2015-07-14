cache ['rss', Post.posts.publicly_viewable.order(publish_at: :desc).first, 'feed'] do
  @posts = Post.posts.publicly_viewable.order(publish_at: :desc).limit(@limit)
  xml.instruct! :xml, :version => "1.0"
  xml.rss(version: '2.0', "xmlns:media" => "http://search.yahoo.com/mrss") {
    xml.channel {
      xml.title("#{t('site_name')}")
      xml.link(request.host)
      xml.description("Exploring sleep with our eyes wide open")

      @posts.each do |post|
        cache post do
          rss_post(xml, post)
        end
      end
    }
  }
end
