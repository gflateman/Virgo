module Virgo
  class SearchController < ApplicationController
    skip_before_action :verify_authenticity_token

    def new
      @search = PostSearch.new
    end

    def create
      @search = PostSearch.new(post_search_params)

      if @search.valid?
        redirect_to search_index_path(post_search: post_search_params)
      else
        render :new
      end
    end

    def index
      if post_search_params.nil?
        redirect_to new_search_path and return
      end

      @search = PostSearch.new(post_search_params)

      @posts = Post.search_by_similarity(@search.term).page(params[:page])
    end

    private

    def post_search_params
      params.permit(post_search: [:term])[:post_search]
    end
  end
end
