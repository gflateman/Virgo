module Platform
  class PageModulesController < ApplicationController
    caches_action :popular_posts,
                  expires_in: 3.minutes,
                  cache_path: ->(o){ "#{deploy_key}/#{site_key}/page_modules/popular_posts/#{params[:category_id]}/#{params[:page]}" }

    def popular_posts
      @category = Category.friendly.find(category_id_param) if category_id_param.present?
      @tabbed = @category.present? ? true : false
      @tab = @category.present? ? :category : :all

      render json: {
        html: render_content(partial: '/page_modules/popular_posts', locals: {category: @category, tab: @tab, tabbed: @tabbed})
      }
    end

    private

    def category_id_param
      params.permit(:category_id)[:category_id]
    end
  end
end
