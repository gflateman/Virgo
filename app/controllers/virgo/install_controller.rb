module Virgo
  class InstallController < ApplicationController
    before_action :deny_if_accounts_exist, except: :success

    helper_method :site_params, :user_params

    def index
    end

    def create
      @user = User.new(user_params.merge(role: :admin))
      @site = Site.instance

      @site.attributes = site_params

      if @site.valid? && @user.valid?
        @site.save!
        @user.save!
        @site.generate_dummy_data!
        redirect_to success_install_index_path
      else
        render :index
      end
    end

    def success
    end

    private

    def deny_if_accounts_exist
      if User.where(role: :admin).any?
        flash[:notice] = "An admin account already exists for this site"
        redirect_to(root_path) and return
      end
    end

    def user_params
      params.permit(user: [:username, :byline, :email, :password, :password_confirmation])[:user]
    end

    def site_params
      params.permit(site: [:name, :tagline, :disqus_app_id])[:site]
    end
  end
end
