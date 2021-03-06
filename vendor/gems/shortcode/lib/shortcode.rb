$:.unshift File.expand_path('..', __FILE__)

require 'parslet'
require 'erb'

begin
  require 'haml'
rescue LoadError; end

begin
  require 'slim'
rescue LoadError; end

module Shortcode

  class << self
    attr_writer :configuration
  end

  def self.process(string, additional_attributes=nil)
    Shortcode::Processor.new.process string, additional_attributes
  end

  def self.setup
    yield configuration
  end

  def self.register_presenter(*presenters)
    presenters.each do |presenter|
      Shortcode::Presenter.register presenter
    end
  end

  private

    def self.configuration
      @configuration ||= Configuration.new
    end

end

require 'shortcode/version'
require 'shortcode/configuration'
require 'shortcode/parser'
require 'shortcode/presenter'
require 'shortcode/processor'
require 'shortcode/template_binding'
require 'shortcode/transformer'
require 'shortcode/tag'
require 'shortcode/exceptions'
require 'shortcode/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3

Shortcode.setup {}
