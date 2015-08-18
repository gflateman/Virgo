class ActiveRecord::Base
  after_save :expire_redis_timestamp
  after_touch :expire_redis_timestamp
  cattr_accessor :_enable_redis_tracking

  def urls
    self.class.urls
  end

  def self.urls
    Rails.application.routes.url_helpers
  end

  def virgo_urls
    self.class.urls
  end

  def self.virgo_urls
    Virgo::Engine.routes.url_helpers
  end

  def expire_site_key
    Rails.cache.write "site_key", "site_key_#{Time.now.to_i}"
  end

  def redis_timestamp
    if enable_redis_tracking
      Rails.cache.fetch(redis_key) do
        "#{redis_key}-#{Time.now.to_i}"
      end
    end
  end

  def redis_key
    if enable_redis_tracking
      if respond_to?(:slug) && slug.present?
        _id = slug
      else
        _id = id
      end

      self.class.redis_timestamp_key_for(self.class, _id)
    end
  end

  def self.redis_timestamp_key_for(klass, record_id)
    "r-#{klass.to_s.underscore}-#{record_id}"
  end

  def expire_redis_timestamp
    if enable_redis_tracking
      Rails.cache.write(redis_key, Time.now.to_i)
    end
  end

  def enable_redis_tracking
    _enable_redis_tracking || false
  end

  def self.enable_redis_tracking
    self._enable_redis_tracking = true
  end

  def view_help
    @view_help ||= ViewHelp.new
  end

  def self.kill_pg_connections!
    db_name = Rails.configuration.database_configuration[Rails.env]['database']
    sql = "
SELECT
  pg_terminate_backend(pg_stat_activity.pid)
FROM
  pg_stat_activity
WHERE
  pg_stat_activity.datname = '#{db_name}' AND pid <> pg_backend_pid();
"
    connection.execute sql
  end
end
