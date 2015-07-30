module Virgo
  class Admin::UsersController < Admin::BaseController
    before_action :set_user, only: member_actions

    handles_sortable_columns

    helper_method :filter_params

    def index
      authorize! :index, User
      @users = User.search(filter_params).with_post_count.order(sort_order).page(params[:page])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        flash[:notice] = "Account created successfully"
        redirect_to admin_users_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      _is_user = current_user == @user

      if @user.update(user_params)
        flash[:notice] = "Profile updated successfully"
        redirect_to edit_admin_user_path(@user)

        # required to keep user signed in (thanks to oddball default
        # devise policy of signing out a user who updates pw)
        sign_in @user, bypass: true if _is_user
      else
        render :edit
      end
    end

    def destroy
      @user.destroy

      flash[:notice] = "User successfully deleted"

      redirect_to admin_users_path
    end

    private

    def set_user
      @user = User.friendly.find(params[:id])
      authorize! :manage, @user
    end

    def user_params
      params.permit(user: [:first_name, :last_name, :byline, :email, :role, :username, :about, :avatar])[:user]
    end

    def user_params
      if params[:user].try(:[], :password).blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      params.permit(user: [:first_name, :last_name, :byline,
                           :show_on_authors_page, :author_page_weight,
                           :email, :role, :username, :about, :avatar,
                           :password, :password_confirmation,
                           :facebook_id, :twitter_id, :instagram_id,
                           :snapchat_id, :linkedin_id, :public_email])[:user]
    end

    def filter_params
      params.permit(filters: [:term])[:filters]
    end
  end
end
