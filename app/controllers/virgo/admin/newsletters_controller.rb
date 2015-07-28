module Virgo
  class Admin::NewslettersController < Admin::BaseController
    before_action :set_site

    layout 'virgo/admin/site_settings'

    def edit
    end

    def update
      authorize! :manage, @site

      if @site.update(site_params)
        flash[:notice] = "Weekly newsletter settings successfully updated"
        redirect_to admin_newsletter_edit_path
      else
        render :edit
      end
    end

    def changelog
      @versions = @site.versions.order(created_at: :desc).page(page_param)
    end

    private

    def set_site
      @site = Site.instance

      authorize! :manage, @site
    end

    def site_params
      params.permit(site: [:weekly_newsletter_intro_copy])[:site]
    end
  end
end
