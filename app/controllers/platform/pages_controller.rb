module Platform
  class PagesController < ApplicationController
    before_action :set_page, only: :show

    def show
      render layout: 'platform/application'
    end

    def home
    end

    def authors
      @authors = User.where(show_on_authors_page: true).order(author_page_weight: :asc)
    end

    def help
    end

    private

    def set_page
      @page = Post.pages.friendly.find(slug_param)
    end

    def slug_param
      params.permit(:slug)[:slug]
    end
  end
end
