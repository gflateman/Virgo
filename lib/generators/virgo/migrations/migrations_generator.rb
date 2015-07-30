module Virgo
  class MigrationsGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../..', __FILE__)

    def copy_migrations
      Dir["#{engine_root}/db/migrate/*.rb"].each do |abs_path|
        relative_path = abs_path.gsub("#{engine_root}/", '')

        unless File.directory?(abs_path)
          copy_file relative_path, relative_path
        end
      end
    end

    def engine_root
      File.expand_path('../../../../..', __FILE__)
    end
  end
end
