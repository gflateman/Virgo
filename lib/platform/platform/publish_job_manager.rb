module Platform
  class PublishJobManager
    attr_accessor :interval

    def self.init!
      instance.setup
      instance.enqueue_immediate!
      true
    end

    def self.notify_complete!
      instance.notify_complete!
    end

    def notify_complete!
      re_enqueue!
    end

    def self.instance
      @instance ||= self.new
    end

    def setup
      self.interval = Rails.application.config.post_scheduling_interval
    end

    def re_enqueue!
      if no_active_job?
        Platform::PublishJob.enqueue(run_at: next_run_time)
      end
    end

    def enqueue_immediate!
      Platform::PublishJob.enqueue
    end

    def next_run_time
      day_start = Time.now.beginning_of_day
      day_end = Time.now.end_of_day

      slots = []
      cur = day_start

      while cur < day_end
        slots << cur
        cur += interval
      end

      nearest_time(slots, Time.now)
    end

    private

    def no_active_job?
      ActiveRecord::Base.connection.execute "select count(*) from que_jobs where job_class = 'Platform::PublishJob' AND error_count = 0;"
      result[0]["count"].to_i == 0
    end

    def nearest_time(slots, val)
      slots.min_by { |x| (x.to_i - val.to_i).abs }
    end
  end
end
