module Virgo
  class Post < ActiveRecord::Base
    module Recommendations
      extend ActiveSupport::Concern

      included do
        def recommendations
          if post_tags.any?
            Post.where.not(id: id).joins(:tags).where("virgo_post_tags.tag_id IN (?)", post_tags.pluck(:tag_id)).uniq.order(created_at: :desc).by_similarity_to(headline)
          end
        end
      end
    end
  end
end
