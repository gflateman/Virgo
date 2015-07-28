module Virgo
  module ShortcodeHelper
    def render_shortcodes(text)
      Shortcode.process(text).try(:html_safe)
    end
  end
end
