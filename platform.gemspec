$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "platform/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "platform"
  s.version     = Platform::VERSION
  s.authors     = ["Nicholas Zaillian"]
  s.email       = ["nzaillian@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Platform."
  s.description = "TODO: Description of Platform."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.2"

  s.add_dependency 'pg'

  s.add_dependency 'sqlite3'

  s.add_dependency 'sass-rails'

  s.add_dependency 'haml'

  s.add_dependency 'uglifier'

  s.add_dependency 'coffee-rails'

  s.add_dependency 'jquery-rails'

  s.add_dependency 'jquery-ui-rails'

  s.add_dependency 'schema_plus'

  s.add_dependency 'jquery-fileupload-rails'

  s.add_dependency 'font-awesome-sass'

  s.add_dependency 'bootstrap-sass'

  s.add_dependency 'kaminari'

  s.add_dependency 'kaminari-bootstrap'

  s.add_dependency 'simple_form'

  s.add_dependency 'breadcrumbs_on_rails'

  s.add_dependency 'tabs_on_rails'

  s.add_dependency 'handles_sortable_columns'

  s.add_dependency 'cancan'

  s.add_dependency 'therubyracer'

  s.add_dependency 'redis-rails'

  s.add_dependency 'chronic'

  s.add_dependency 'turbolinks'

  s.add_dependency 'jbuilder'

  s.add_dependency 'sdoc'

  s.add_dependency 'devise'

  s.add_dependency 'roadie'

  s.add_dependency 'roadie-rails'

  s.add_dependency 'sitemap_generator'

  s.add_dependency 'fog'

  s.add_dependency 'fog-aws'

  s.add_dependency 'carrierwave'

  s.add_dependency 'mini_magick'

  s.add_dependency 'friendly_id'

  s.add_dependency 'que'

  s.add_dependency 'select2-rails'

  s.add_dependency 'httparty'

  s.add_dependency 'whenever'

  s.add_dependency 'exception_notification'

  s.add_dependency 'highline'

  s.add_dependency 'momentjs-rails', '>= 2.9.0'

  s.add_dependency 'bootstrap3-datetimepicker-rails'

  s.add_dependency 'nokogiri'

  s.add_dependency 'actionpack-action_caching'

  s.add_dependency 'shortcode'

  s.add_dependency 'paper_trail'

  s.add_dependency 'local_time'

  s.add_dependency 'tinymce-rails'

  s.add_dependency 'non-stupid-digest-assets'

  s.add_dependency 'rest-client'

  s.add_dependency 'gibbon'

  s.add_dependency 'newrelic_rpm'

  s.add_dependency 'geoip'

  s.add_dependency 'geokit'

  s.add_dependency 'htmlentities'

  s.add_development_dependency 'capistrano', '3.4.0'

  s.add_development_dependency 'capistrano-rails'

  s.add_development_dependency 'capistrano-rvm'

  s.add_development_dependency 'capistrano-bundler'

  s.add_development_dependency 'capistrano-rails-console'

  s.add_development_dependency 'capistrano-rails-tail-log'

  s.add_development_dependency 'rspec-rails'

  s.add_development_dependency 'capybara'

  s.add_development_dependency 'faker'

  s.add_development_dependency 'database_cleaner'

  s.add_development_dependency 'selenium-webdriver'

  s.add_development_dependency 'chromedriver-helper'

  s.add_development_dependency 'factory_girl_rails'

  s.add_development_dependency 'pry'
end
