module Virgo
  module HooksHelper
    def hook(hook_name)
      body = ""

      (@hook_content[hook_name] || []).each do |markup|
        body += raw(markup)
      end

      body
    end

    def for_hook(hook_name, &block)
      markup = capture(&block)

      add_hook_content(hook_name, markup)

      "" # just in case the user echoes the helper invocation
    end

    private

    # do not call directly
    def add_hook_content(hook_name, content)
      @hook_content ||= {}
      @hook_content[hook_name] ||= []
      @hook_content[hook_name] << content
    end
  end
end
