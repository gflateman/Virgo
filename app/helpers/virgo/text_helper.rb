# Source:
# http://blog.madebydna.com/all/code/2010/06/04/ruby-helper-to-cleanly-truncate-html.html

require 'nokogiri'

module Virgo
  module TextHelper
    def strip_read_more(text)
      text.gsub('[read-more]', '').html_safe
    end
  end
end
