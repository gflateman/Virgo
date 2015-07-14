module Platform
  class Admin::SitesController < Admin::BaseController
    before_action :set_site

    layout 'admin/site_settings'

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

    private

    def set_site
      @site = Site.instance

      authorize! :manage, @site
    end

    def site_params
      params.permit(site: [:tagline])[:site]
    end
  end
end
