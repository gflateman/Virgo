module Virgo
  class MigrationsGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../..', __FILE__)

    def copy_migrations
      timestamp_str = Time.zone.now.strftime("%Y%m%d%H%M%S").to_s
      src_path = "#{engine_root}/db/migrate/create_virgo_schema.rb"
      dest_path = "#{Rails.root}/db/migrate/#{timestamp_str}_create_virgo_schema.rb"

      unless File.directory?(dest_path)
        copy_file src_path, dest_path
      end
    end

    def engine_root
      File.expand_path('../../../../..', __FILE__)
    end
  end
end
