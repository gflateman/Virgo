module Virgo
  class ApplicationController < ActionController::Base
    include Virgo::RenderHelper, Virgo::ApplicationHelper, ActionView::Helpers::SanitizeHelper, ActionView::Helpers::TextHelper

    layout 'virgo/main'

    protect_from_forgery with: :exception

    before_action :init

    before_action :configure_permitted_parameters, if: :devise_controller?

    before_action :set_client_id

    helper_method :render_to_string, :just_confirmed?, :deploy_key, :filter_params


    # Graceful error handling - commented out b/c it is difficult (impossible?)
    # to override these rescues in a decorator - if you like the strategy
    # set config.enable_virgo_error_handlers = true in an initializer
    #
    if Rails.application.config.enable_virgo_error_handlers
      rescue_from Exception, with: :render_500
      rescue_from ActiveRecord::RecordNotFound, with: :render_404
      rescue_from CanCan::AccessDenied, with: :render_404
      rescue_from ActionController::RoutingError, with: :render_404
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
    end

    def default_url_options
      {:host => Rails.application.config.domain}
    end

    private

    def self.member_actions(*extras)
      [:show, :edit, :update, :destroy] + extras
    end

    def self.collection_actions(*extras)
      [:index, :new, :create] + extras
    end

    def self.default_sort_order(val)
      @_default_sort_order = val
    end

    def sort_order
      order = sortable_column_order do |column, direction|
        # make the sort on these select string columns case-insensitive w/ LOWER function
        if column && column.in?(['name', 'headline'])
          "LOWER(#{column}) #{direction}"
        elsif column
          "#{column} #{direction}"
        else
          @_default_sort_order || "updated_at DESC"
        end
      end
    end

    def set_calendar
      @calendar = Calendar.friendly.find(params[:id] || params[:calendar_id])
    end

    def just_confirmed_param
      params.permit(:just_confirmed)[:just_confirmed]
    end

    def just_confirmed?
      just_confirmed_param && (just_confirmed_param.in?([true, 'true']))
    end

    def render_500(exception)
      logger.error exception.backtrace.join("\n")
      notify_exception(request.env, exception)
      render "virgo/errors/500", layout: "virgo/errors", status: 500
    end

    def render_404
      if request.format.json? || request.format.js?
        render(json: {status: "Not found"}, status: 404)
      else
        render "virgo/errors/404", layout: "virgo/errors", status: 404
      end
    end

    def notify_exception(env, exception)
      if ['production', 'staging'].include?(Rails.env)
         # stub for your exception handling code...
      end
    end

    def self.deploy_key
      Rails.application.config.deploy_key
    end

    def deploy_key
      self.class.deploy_key
    end

    def after_sign_out_path_for(resource_or_scope)
      virgo.new_user_session_path
    end

    def set_client_id
      cookies[:client_id] ||= SecureRandom.hex(14)
    end

    def client_id
      cookies[:client_id]
    end

    def filter_params
      params.permit(filters: [:term])[:filters]
    end

    def init
      @_large_nav = false
    end

    def enable_large_nav
      @_large_nav = true
    end

    def current_ability
       @current_ability ||= ::Virgo::Ability.new(current_user)
    end
  end
end
