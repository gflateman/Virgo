module Virgo
  class PostTag < ActiveRecord::Base
    belongs_to :post
    belongs_to :tag

    validates :tag_id, uniqueness: {scope: :post_id}

    scope :by_position, ->{ order(position: :asc) }
  end
end
