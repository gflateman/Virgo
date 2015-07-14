module Platform
  class CategoriesController < ApplicationController
    caches_action :show, if: ->{ current_user.nil? && flash.empty? },
                  cache_path: ->(o){ "#{deploy_key}/#{site_key}/categories/show/#{params[:id]}/#{category_timestamp(params[:id])}/#{params[:page]}" }

    def show
      set_category

      @posts = @category.posts.exclude_category_feature(@category).order(publish_at: :desc).page(page_param)

      template_name = @category.name == 'Resources' ? '/categories/resources' : '/categories/show'

      render template_name, layout: 'posts'
    end

    private

    def set_category
      @category = Category.friendly.find(id_param)
    end
  end
end
