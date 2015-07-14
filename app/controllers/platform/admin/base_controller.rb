module Platform
  class Admin::BaseController < ApplicationController
    newrelic_ignore

    layout 'admin'
    before_filter :authorize_admin_user
    before_filter :set_is_admin_view

    def search
      redirect_to params.merge(action: "index").to_hash
    end

    def authorize_admin_user
      unless user_signed_in? and current_user.admin_access?
        redirect_to root_path, notice: 'You do not have permission to access admin pages.'
      end
    end

    def set_is_admin_view
      @_is_admin_view = true
    end
  end
end
