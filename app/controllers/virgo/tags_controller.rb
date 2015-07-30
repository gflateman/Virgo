module Virgo
  class TagsController < ApplicationController
    before_action :set_tag

    def show
      @posts = @tag.posts.publicly_viewable.order(publish_at: :desc).page(params[:page])
    end

    private

    def set_tag
      @tag = Tag.friendly.find(params[:id])
    end
  end
end
