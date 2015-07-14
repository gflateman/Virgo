module Platform
  class Engine < ::Rails::Engine
    isolate_namespace Platform

    config.autoload_paths << File.expand_path("..", __FILE__)

    # some dependencies must be explicitly required if used in an engine...
    require 'friendly_id'
    require 'carrierwave'
  end
end
