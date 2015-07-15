require 'devise'

module Platform
  class Engine < ::Rails::Engine
    isolate_namespace Platform

    config.autoload_paths << File.expand_path("..", __FILE__)

    config.caching = :aggressive

    # some dependencies must be explicitly required if used in an engine...
    require 'friendly_id'
    require 'kaminari'
    require 'carrierwave'
    require 'cancan'
    require 'handles_sortable_columns'
    require 'action_controller/action_caching.rb'
    require 'htmlentities'
    require 'jquery-rails'
    require 'jquery-ui-rails'
    require 'jquery-fileupload-rails'
    require 'bootstrap-sass'
    require 'font-awesome-sass'
    require 'bootstrap3-datetimepicker-rails'
    require 'select2-rails'
    require 'momentjs-rails'
    require 'local_time'
    require 'tinymce-rails'
    require 'chronic'


    spec = Gem::Specification.find_by_name("local_time")
    gem_root = spec.gem_dir
    require "#{gem_root}/app/helpers/local_time_helper"

    ActionView::Base.send :include, ::LocalTimeHelper

    initializer :append_migrations do |app|
      unless app.root.to_s == root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
  end
end
