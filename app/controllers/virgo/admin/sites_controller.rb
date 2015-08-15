module Virgo
  class Admin::SitesController < Admin::BaseController
    before_action :set_site

    layout 'virgo/admin/site_settings'

    def edit
    end

    def update
      if @site.update(site_params)
        flash[:notice] = "Site settings saved"
        redirect_to admin_site_edit_path
      else
        render :edit
      end
    end


    def styles
      if request.patch?
        if @site.update(site_params)
          flash[:notice] = "Site styles saved"
          redirect_to admin_site_styles_path
        else
          render :styles
        end
      end
    end

    private

    def set_site
      @site = Site.instance

      authorize! :manage, @site
    end

    def site_params
      params.permit(site: [:name, :description, :style_overrides, :tagline, :disqus_app_id, :twitter_handle, :instagram_account_name, :pinterest_account_name])[:site]
    end
  end
end
