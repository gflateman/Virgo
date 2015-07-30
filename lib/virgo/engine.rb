module Virgo
  class Engine < ::Rails::Engine
    isolate_namespace Virgo

    config.autoload_paths << File.expand_path("..", __FILE__)

    config.caching = :aggressive

    config.require_posts_to_have_category = false

    config.domain = 'localhost'

    config.edit_lock_timeout = 8.seconds

    config.edit_lock_grace = 10.seconds

    config.post_locking_enabled = true

    config.deploy_key = Digest::MD5.hexdigest(Dir["#{Rails.root}/public/assets/**/*"].join(':'))

    # some dependencies must be explicitly required if used in an engine...
    require 'devise'
    require 'kaminari-bootstrap'
    require 'friendly_id'
    require 'kaminari'
    require 'kaminari-bootstrap'
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

    require File.expand_path("../../../vendor/gems/shortcode/lib/shortcode", __FILE__)


    spec = Gem::Specification.find_by_name("local_time")
    gem_root = spec.gem_dir
    require "#{gem_root}/app/helpers/local_time_helper"

    ActionView::Base.send :include, ::LocalTimeHelper

    config.to_prepare do
      # Load application's model / class decorators
      Dir["#{Rails.root}/app/**/*_decorator*.rb"].each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
