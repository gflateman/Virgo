module Virgo
  class Post < ActiveRecord::Base
    module Search
      extend ActiveSupport::Concern

      included do
        scope :search, ->(filters=nil) {
          filters ||= {}

          items = all


          if filters[:post_type].present?
            items = items.where(post_type: filters[:post_type])
          else
            items = items.where(post_type: 'post') # default
          end

          if filters[:category].present?
            filters[:category_ids] = [filters[:category]]
          end

          if filters[:category_ids].present?
            filters[:category_ids].each_with_index do |id, i|
              items = items.joins(
                "INNER JOIN virgo_post_categories pc#{i} ON virgo_posts.id = pc#{i}.post_id AND pc#{i}.category_id = #{id.to_i}"
              )
            end
          end

          if filters[:status].present?
            items = items.where(status: filters[:status])
          end

          if filters[:tag_ids].present?
            filters[:tag_ids].each_with_index do |id, i|
              items = items.joins(
                "INNER JOIN virgo_post_tags pt#{i} ON virgo_posts.id = pt#{i}.post_id AND pt#{i}.tag_id = #{id.to_i}"
              )
            end
          end

          if filters[:term].present?
            items = items.where("virgo_posts.headline ILIKE :term", term: "%#{filters[:term]}%")
          end

          if filters[:user_ids].present?
            items = items.where("virgo_posts.author_id IN (?)", filters[:user_ids])
          end

          if filters[:month].present?
            month = Chronic.parse(filters[:month])

            items = items.for_month(month)
          end

          items
        }

        scope :search_by_similarity, ->(term){
          items = posts.publicly_viewable

          if term.present?
            parts = term.split(" ")
            queries = []
            vals = {}

            parts.each_with_index do |part, i|
              vals[:"term_#{i}"] = "%#{part}%"

              queries << "(virgo_posts.search_document ILIKE :term_#{i})"
            end

            query  = queries.join(" OR ")

            items = items.where(query, vals)

            longest_term = parts.max_by {|t| t.length}

            items = items.by_similarity_to(longest_term)
          end

          items
        }

        scope :by_similarity_to, ->(text) {
          sanitized = connection.quote(text)
          select("virgo_posts.*, SIMILARITY(virgo_posts.search_document, #{sanitized}) AS search_similarity").order("search_similarity DESC")
        }

        scope :search_by_headline, ->(term) {
          Virgo::Post.where("headline ILIKE :term", term: "%#{term}%")
        }

        def self.reindex!
          Virgo::Post.find_each do |post|
            post.send :generate_search_document, force: true
            post.save!
          end
        end
      end
    end
  end
end
