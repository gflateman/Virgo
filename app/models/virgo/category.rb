module Virgo
  class Category < ActiveRecord::Base
    enable_redis_tracking

    extend FriendlyId

    friendly_id :name, use: :slugged

    has_many :post_categories, dependent: :destroy
    has_many :posts, ->{ where(post_type: :post) }, through: :post_categories

    belongs_to :parent, class_name: 'Virgo::Category'

    belongs_to :created_by, class_name: 'Virgo::User'

    has_many :children, class_name: 'Virgo::Category', foreign_key: :parent_id

    validates :name, presence: true, uniqueness: true

    scope :visible, ->{ where(visible: true) }

    scope :by_weight, ->{ order(navbar_weight: :asc) }

    scope :navbar, ->{ where(display_in_navbar: true).by_weight }

    scope :bottom_level, ->{
      where("virgo_categories.id NOT IN (SELECT DISTINCT virgo_categories.parent_id FROM virgo_categories WHERE virgo_categories.parent_id IS NOT NULL)")
    }

    scope :top_level, ->{
      where(parent_id: nil)
    }

    scope :with_post_count, ->{
      select("virgo_categories.*, " +
        "(SELECT COUNT(*) FROM virgo_post_categories WHERE virgo_post_categories.category_id = virgo_categories.id) AS post_count"
      )
    }

    def self.COLUMNS
      find_by(name: "Columns")
    end
  end
end
