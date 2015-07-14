module Platform
  class Admin::Users::SessionsController < Admin::BaseController
    include Devise::Controllers::Helpers

    before_filter :find_user, only: [:create]

    def create
      sign_out(current_user)

      sign_in(@user)

      redirect_to root_path, flash: {notice: "You have been logged in as #{@user.email}"}
    end

    private

    def find_user
      @user = User.friendly.find(params[:user_id])
    end
  end
end
