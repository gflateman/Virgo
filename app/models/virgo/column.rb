module Virgo
  class Column < ActiveRecord::Base
    enable_redis_tracking

    extend FriendlyId

    friendly_id :name, use: :slugged

    mount_uploader :image, Virgo::FeaturedImageUploader

    validates :name, presence: true

    has_many :posts

    after_save :expire_site_key

    scope :with_post_count, ->{
      select("virgo_columns.*, " +
        "(SELECT COUNT(*) FROM virgo_posts WHERE virgo_posts.column_id = virgo_columns.id) AS post_count"
      )
    }

    scope :by_weight, ->{ order(weight: :asc) }
  end
end
