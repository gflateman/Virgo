module Platform
  class InstallGenerator < Rails::Generators::Base
    def run_install
      unless app_has_engine_route?
        route "mount Platform::Engine => \"/\""
      end

      generate "platform:views"
    end

    def app_has_engine_route?
      route_contents = File.read("#{Rails.root}/config/routes.rb")
      route_contents.include?("Platform::Engine")
    end
  end
end
