require File.expand_path "../../../app/helpers/virgo/video_helper", __FILE__
require 'shortcode'

template_root = File.expand_path "../../../app/views/virgo/shortcode_templates", __FILE__
app_template_root = "#{Rails.root}/app/views/virgo/shortcode_templates"

Shortcode.setup do |config|
  config.template_parser = :haml
  config.helpers = [Virgo::VideoHelper]
  config.block_tags = [:pullquote, :blockquote, :h1, :h2, :h3, :h4]
  config.self_closing_tags = [:image, :video, :tweet, :slideshow]
  config.template_paths.prepend(template_root)
  config.template_paths.prepend(app_template_root)
end
