require 'devise'

module Platform
  class Engine < ::Rails::Engine
    isolate_namespace Platform

    config.autoload_paths << File.expand_path("..", __FILE__)

    config.caching = :aggressive

    # some dependencies must be explicitly required if used in an engine...
    require 'friendly_id'
    require 'carrierwave'
    require 'action_controller/action_caching.rb'

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
  end
end
