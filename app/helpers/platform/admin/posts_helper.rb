module Platform
  module Admin
    module PostsHelper
      def admin_post_month_options
        return [] if Post.where.not(publish_at: nil).empty?

        min_date = Post.minimum(:publish_at).try(:to_date)
        max_date = Time.now.to_date

        date_range = min_date..max_date

        month_names = []
        added = {}

        date_range.map {|d|
          date = Date.new(d.year, d.month, 1)
          if added[date].nil?
            month_names << [date.to_s(:month_and_year), date.to_s(:db)]
            added[date] = true
          end
        }.uniq

        month_names.reverse
      end

      def admin_post_category_options(category=nil, depth=0)
        select_options = []

        if category.nil?
          categories = Category.top_level
        else
          categories = [category]
        end

        categories.each do |cat|
          # base case
          spaces = (0..depth-1).map{|i| "&nbsp;&nbsp;&nbsp;" }.join("")
          select_option = ["#{spaces}#{cat.name}".html_safe, cat.id]
          select_options << select_option

          cat.children.each do |child|
            select_options += admin_post_category_options(child, depth + 1)
          end
        end

        select_options
      end

      def admin_post_status_options
        Post.status_names
      end
    end
  end
end
