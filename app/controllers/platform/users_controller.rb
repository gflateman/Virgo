module Platform
  class UsersController < ApplicationController
    before_filter :set_user, only: member_actions

    def show
      @posts = @user.posts.latest.page(page_param)
    end

    private

    def set_user
      @user = User.friendly.find(id_param)
    end
  end
end
