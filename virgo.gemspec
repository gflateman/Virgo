$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "virgo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "virgo"
  s.version     = Virgo::VERSION
  s.authors     = ["Nicholas Zaillian"]
  s.email       = ["nzaillian@gmail.com"]
  s.homepage    = "http://caspersleep.github.io/Virgo"
  s.summary     = "A blogging engine for Ruby on Rails"
  s.description = "Virgo is a comprehensive team blogging tool for Ruby on Rails"
  s.license     = "GPL v2"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'rails', '~> 4.2.2'

  s.add_dependency 'pg'

  s.add_dependency 'sass-rails'

  s.add_dependency 'haml'

  s.add_dependency 'uglifier'

  s.add_dependency 'coffee-rails'

  s.add_dependency 'jquery-rails'

  s.add_dependency 'jquery-ui-rails'

  s.add_dependency 'schema_plus', '~> 2.0.0'

  s.add_dependency 'jquery-fileupload-rails', '0.4.5'

  s.add_dependency 'font-awesome-sass', '~> 4.3.2.1'

  s.add_dependency 'bootstrap-sass', '~> 3.3.5.1'

  s.add_dependency 'kaminari', '~> 0.16.3'

  s.add_dependency 'kaminari-bootstrap'

  s.add_dependency 'simple_form', '~> 3.1.0'

  s.add_dependency 'breadcrumbs_on_rails', '~> 2.3.0'

  s.add_dependency 'tabs_on_rails', '~> 2.2.0'

  s.add_dependency 'handles_sortable_columns', '~> 0.1.4'

  s.add_dependency 'cancan', '~> 1.6.10'

  s.add_dependency 'therubyracer', '~> 0.12.2'

  s.add_dependency 'redis-rails'

  s.add_dependency 'chronic', '~> 0.10.2'

  s.add_dependency 'jbuilder'

  s.add_dependency 'sdoc'

  s.add_dependency 'devise', '>= 3.2.4'

  s.add_dependency 'carrierwave', '~> 0.10.0'

  s.add_dependency 'mini_magick'

  s.add_dependency 'friendly_id', '>= 5.0.5'

  s.add_dependency 'select2-rails', '>= 3.5.9.1'

  s.add_dependency 'whenever', '~> 0.9.4'

  s.add_dependency 'momentjs-rails', '~> 2.9.0'

  s.add_dependency 'bootstrap3-datetimepicker-rails', '~> 4.14.30'

  s.add_dependency 'nokogiri'

  s.add_dependency 'actionpack-action_caching'

  s.add_dependency 'paper_trail', '~> 3.0.8'

  s.add_dependency 'local_time', '~> 1.0.2'

  s.add_dependency 'tinymce-rails', '~> 4.2.1'

  s.add_dependency 'htmlentities', '~> 4.3.4'

  s.add_dependency 'faker', '~> 1.4.3'

  s.add_dependency 'parslet', '~> 1.7.0'

  s.add_dependency 'coveralls', '~> 0.8.2'

  s.add_development_dependency 'rspec-rails'

  s.add_development_dependency 'capybara'

  s.add_development_dependency 'database_cleaner'

  s.add_development_dependency 'selenium-webdriver'

  s.add_development_dependency 'chromedriver-helper'

  s.add_development_dependency 'factory_girl_rails'

  s.add_development_dependency 'pry'
end
