module Virgo
  class Tag < ActiveRecord::Base
    extend FriendlyId

    friendly_id :name, use: :slugged

    has_many :post_tags, dependent: :destroy
    has_many :posts, through: :post_tags

    belongs_to :created_by, class_name: 'Virgo::User'

    validates :name, presence: true, uniqueness: {case_sensitive: false}

    scope :with_post_count, ->{
      select("virgo_tags.*, " +
        "(SELECT COUNT(*) FROM virgo_post_tags WHERE virgo_post_tags.tag_id = virgo_tags.id) AS post_count"
      )
    }

    def self.cache_key
      "taga-#{maximum(:updated_at).try(:to_i)}-#{all.size}"
    end

    scope :search, ->(filters={}){
      items = all

      if filters[:term].present?
        items = items.where("virgo_tags.name ILIKE :term", term: "%#{filters[:term]}%")
      end

      items
    }
  end
end
