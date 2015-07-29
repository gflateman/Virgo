module Virgo
  class Slideshow < ActiveRecord::Base
    validates :name, presence: true
    after_save :expire_site_key
    after_save :expire_containing_posts

    belongs_to :author, class_name: 'Virgo::User'
    has_many :slides, dependent: :destroy

    scope :search, ->(filters=nil) {
      filters ||= {}

      items = all

      if filters[:term].present?
        if filters[:term].to_i
          items = items.where("slideshows.name ILIKE :term_wildcard OR slideshows.id = :term", term_wildcard: "%#{filters[:term]}%", term: filters[:term].to_i)
        else
          items = items.where("slideshows.name ILIKE :term_wildcard", term_wildcard: "%#{filters[:term]}%")
        end
      end

      items
    }


    def containing_posts
      Post.containing_slideshow(self)
    end

    private

    def expire_containing_posts
      containing_posts.map &:touch
    end
  end
end
