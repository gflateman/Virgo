module Virgo
  class Admin::SlideshowsController < Admin::BaseController
    handles_sortable_columns

    before_action :set_slideshow, only: member_actions

    helper_method :filter_params

    def index
      if params[:sort].blank?
        flash.keep
        redirect_to admin_slideshows_path(sort: '-created_at') and return
      end

      @slideshows = Slideshow.joins(:author).search(filter_params).order(sort_order).page(params[:page])
    end

    def new
      @slideshow = Slideshow.new
    end

    def create
      @slideshow = Slideshow.new(slideshow_params)

      if @slideshow.save
        flash[:notice] = "Slideshow successfully created. You can add slides below."
        redirect_to edit_admin_slideshow_path(@slideshow)
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @slideshow.update(slideshow_params)
        flash[:notice] = "Slideshow settings saved"
        redirect_to edit_admin_slideshow_path(@slideshow)
      else
        render :edit
      end
    end

    def destroy
      authorize! :destroy, @slideshow
      @slideshow.destroy
      flash[:notice] = "Slideshow deleted"
      redirect_to admin_slideshows_path
    end

    private

    def set_slideshow
      @slideshow = Slideshow.find(params[:id])
    end

    def slideshow_params
      params.permit(slideshow: [:name, :author_id])[:slideshow]
    end

    def filter_params
      params.permit(filters: [:term])[:filters]
    end
  end
end
