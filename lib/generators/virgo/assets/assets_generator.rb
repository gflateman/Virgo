module Virgo
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../..', __FILE__)

    def copy_views
      Dir["#{engine_root}/app/assets/**/*"].reject { |f|
        f.include?('admin') ||
        f.include?('tinymce')
      }.each do |abs_path|
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
