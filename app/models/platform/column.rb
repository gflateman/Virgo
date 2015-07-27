module Platform
  class Column < ActiveRecord::Base
    enable_redis_tracking

    extend FriendlyId

    friendly_id :name, use: :slugged

    mount_uploader :image, Platform::FeaturedImageUploader

    validates :name, presence: true

    has_many :posts

    after_save :expire_site_key

    scope :with_post_count, ->{
      select("platform_columns.*, " +
        "(SELECT COUNT(*) FROM platform_posts WHERE platform_posts.column_id = platform_columns.id) AS post_count"
      )
    }

    scope :by_weight, ->{ order(weight: :asc) }
  end
end
