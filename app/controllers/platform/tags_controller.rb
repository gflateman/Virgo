module Platform
  class TagsController < ApplicationController
    before_action :set_tag

    def show
      @posts = @tag.posts.publicly_viewable.order(publish_at: :desc).page(page_param)
    end

    private

    def set_tag
      @tag = Tag.friendly.find(id_param)
    end
  end
end
