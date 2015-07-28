module Virgo
  class Admin::PageModulesController < Admin::BaseController
    before_action :set_site
    before_action :set_page_module, only: [:edit_subject]

    layout 'virgo/admin/site_settings'

    def edit
      authorize! :manage, PageModule

      @page_modules = PageModule.visible_to_admins.order(weight: :asc)
    end

    def edit_subject
      if request.patch?
        if @page_module.update(page_module_params)
          @page_module.page_module_posts.map &:destroy
          if post_id_params.present?
            post_id_params.each_with_index do |post_id, index|
              @page_module.page_module_posts.create!(post_id: post_id, position: index)
            end
          end
          flash[:notice] = "Settings updated successfully"
          redirect_to admin_edit_page_module_subject_path(@page_module) and return
        end
      end
    end

    def update
      authorize! :manage, PageModule

      params[:page_modules].each_pair do |id, enabled_val|
        page_module = PageModule.find(id)

        page_module.update!(enabled: enabled_val)
      end

      flash[:notice] = "Page module settings updated"

      redirect_to admin_page_modules_edit_path
    end

    private

    def set_site
      @site = Site.instance

      authorize! :manage, @site
    end

    def set_page_module
      @page_module = PageModule.find(id_param)
    end

    def post_id_params
      params.permit(post_ids: [])[:post_ids]
    end
    def page_module_params
      params.permit(page_module: [:subject_id, :subject_type, :image])[:page_module]
    end
  end
end
