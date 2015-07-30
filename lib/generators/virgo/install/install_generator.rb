module Virgo
  class InstallGenerator < Rails::Generators::Base
    def run_install
      unless app_has_engine_route?
        in_root do
          inject_into_file 'config/routes.rb',"\n  mount Virgo::Engine => \"/\"\n", { before: /^end/, verbose: false, force: true }
        end
      end

      generate "virgo:views"
      generate "virgo:migrations"
      generate "virgo:schedule"
    end

    def app_has_engine_route?
      route_contents = File.read("#{Rails.root}/config/routes.rb")
      route_contents.include?("Virgo::Engine")
    end
  end
end
