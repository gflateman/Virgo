Shortcode.setup do |config|
  config.template_parser = :haml
  config.helpers = [VideoHelper]
  config.block_tags = [:pullquote, :blockquote, :h1, :h2, :h3, :h4]
  config.self_closing_tags = [:image, :video, :tweet, :slideshow]
end
