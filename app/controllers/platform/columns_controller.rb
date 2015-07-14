module Platform
  class ColumnsController < ApplicationController
    caches_action :show, if: ->{ current_user.nil? && flash.empty? },
                  cache_path: ->(o){ "#{deploy_key}/#{site_key}/columns/show/#{params[:id]}/#{column_timestamp(params[:id])}/#{params[:page]}" }

    before_action :set_column, only: [:show]

    def index
      @columns = Column.by_weight

      render layout: '/layouts/posts'
    end

    def show
      @posts = @column.posts.latest.page(page_param)
    end

    private

    def set_column
      @column = Column.friendly.find(id_param)
    end
  end
end
