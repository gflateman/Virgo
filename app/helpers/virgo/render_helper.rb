module Virgo
  module RenderHelper
    def with_format(format, &block)
      old_formats = formats
      self.formats = [format]
      block.call
      self.formats = old_formats
      nil
    end

    # render_to_string, except force formats = [:html]
    # if none are explicitly provided (so you can call
    # from a controller action body responding to a json
    # request and still render out a html partial by default)
    def render_content(*args, &block)
      augmented_args = _normalize_args(*args, &block)

      augmented_args[:formats] ||= []

      augmented_args[:formats] = [:html] unless augmented_args[:formats].include?(:html)

      # declare so below reference is not block-local
      content = ""

      # necessary to not receive warnings (see above)
      with_format :html do
        content = render_to_string(augmented_args)
      end

      content.html_safe
    end
  end
end
