module Virgo
  class ScheduleGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../..', __FILE__)

    def copy_schedule
      abs_path = "#{engine_root}/config/schedule.rb"
      relative_path = abs_path.gsub("#{engine_root}/", '')
      copy_file relative_path, relative_path
    end

    def engine_root
      File.expand_path('../../../../..', __FILE__)
    end
  end
end
