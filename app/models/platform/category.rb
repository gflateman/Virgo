module Platform
  class Category < ActiveRecord::Base
    enable_redis_tracking

    extend FriendlyId

    friendly_id :name, use: :slugged

    has_many :post_categories, dependent: :destroy
    has_many :posts, ->{ where(post_type: :post) }, through: :post_categories

    belongs_to :parent, class_name: 'Category'

    belongs_to :created_by, class_name: 'User'

    has_many :children, class_name: 'Category', foreign_key: :parent_id

    validates :name, presence: true, uniqueness: true

    scope :visible, ->{ where(visible: true) }

    scope :by_weight, ->{ order(navbar_weight: :asc) }

    scope :navbar, ->{ where(display_in_navbar: true).by_weight }

    scope :bottom_level, ->{
      where("platform_categories.id NOT IN (SELECT DISTINCT platform_categories.parent_id FROM platform_categories WHERE platform_categories.parent_id IS NOT NULL)")
    }

    scope :top_level, ->{
      where(parent_id: nil)
    }

    scope :with_post_count, ->{
      select("platform_categories.*, " +
        "(SELECT COUNT(*) FROM platform_post_categories WHERE platform_post_categories.category_id = platform_categories.id) AS post_count"
      )
    }

    def self.COLUMNS
      find_by(name: "Columns")
    end
  end
end
