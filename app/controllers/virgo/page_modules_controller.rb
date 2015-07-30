module Virgo
  class PageModulesController < ApplicationController
    caches_action :popular_posts,
                  expires_in: 3.minutes,
                  cache_path: ->(o){ "#{deploy_key}/#{site_key}/page_modules/popular_posts/#{params[:category_id]}/#{params[:page]}" }

    def popular_posts
      @category = Category.friendly.find(params[:category_id]) if params[:category_id].present?
      @tabbed = @category.present? ? true : false
      @tab = @category.present? ? :category : :all

      render json: {
        html: render_content(partial: '/virgo/page_modules/popular_posts', locals: {category: @category, tab: @tab, tabbed: @tabbed})
      }
    end
  end
end
