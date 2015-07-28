module Virgo
  class InstallGenerator < Rails::Generators::Base
    def run_install
      unless app_has_engine_route?
        route "mount Virgo::Engine => \"/\""
      end

      generate "virgo:views"
    end

    def app_has_engine_route?
      route_contents = File.read("#{Rails.root}/config/routes.rb")
      route_contents.include?("Virgo::Engine")
    end
  end
end
