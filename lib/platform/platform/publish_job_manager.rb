module Platform
  class PublishJobManager
    attr_accessor :interval

    def self.init!
      instance.setup
      instance.enqueue_immediate!
      Que.logger.info "PublishJobManager initialized!"
      true
    end

    def self.notify_complete!
      Que.logger.info "PublishJobManager notified of job completion"
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
      no_active_job = no_active_job?

      Que.logger.info "Re-enqueue requested...active job running?: #{no_active_job ? 'No' : 'Yes'}"

      if no_active_job
        Que.logger.info "Enqueing new run of PublishJob - run_at: #{next_run_time}"
        Platform::PublishJob.enqueue(run_at: next_run_time)
      end
    end

    def enqueue_immediate!
      Que.logger.info "PublishJobManager job enqueued for immediate execution"
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
      result = ActiveRecord::Base.connection.execute "select count(*) from que_jobs where job_class = 'Platform::PublishJob' AND error_count = 0;"
      result[0]["count"].try(:to_i) == 0
    end

    def nearest_time(slots, val)
      slots.min_by { |x| (x.to_i - val.to_i).abs }
    end
  end
end
