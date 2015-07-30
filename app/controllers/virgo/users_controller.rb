module Virgo
  class UsersController < ApplicationController
    before_filter :set_user, only: member_actions

    def show
      @posts = @user.posts.latest.page(params[:page])
    end

    private

    def set_user
      @user = User.friendly.find(params[:id])
    end
  end
end
