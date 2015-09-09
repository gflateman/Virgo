module Virgo
  class User < ActiveRecord::Base
    module Search
      extend ActiveSupport::Concern

      included do
        scope :search, ->(filters=nil) {
          filters ||= {}

          items = all

          if filters[:term].present?
            parts = filters[:term].split(" ")
            queries = []
            vals = {}

            parts.each_with_index do |part, i|
              vals[:"term_#{i}"] = "%#{part}%"

              queries << \
                "(virgo_users.email ILIKE :term_#{i} OR " +
                "virgo_users.first_name ILIKE :term_#{i} OR " +
                "virgo_users.last_name ILIKE :term_#{i} OR " +
                "virgo_users.username ILIKE :term_#{i} OR " +
                "virgo_users.byline ILIKE :term_#{i})"
            end

            query  = queries.join(" OR ")

            items = items.where(query, vals)
          end


          items
        }
      end
    end
  end
end
