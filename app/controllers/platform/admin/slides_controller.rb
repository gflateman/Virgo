module Platform
  class Admin::SlidesController < Admin::BaseController
    before_action :set_slideshow, only: collection_actions
    before_action :set_slide, only: member_actions

    def new
      @slide = @slideshow.slides.new
    end

    def create
      @slide = Slide.new(slide_params)

      if @slide.save
        flash[:notice] = "Your new slide has been added"
        redirect_to edit_admin_slideshow_path(@slide.slideshow)
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @slide.update(slide_params)
        flash[:notice] = "Slide settings updated"
        redirect_to edit_admin_slideshow_path(@slide.slideshow)
      else
        render :edit
      end
    end

    def positions
      slide_data = params[:slides]

      slide_data.values.each do |data|
        slide = Slide.find(data[:id])
        authorize! :manage, slide
        slide.update!(position: data[:position])
      end


      head :ok
    end

    def destroy
      authorize! :destroy, @slide
      @slide.destroy
      flash[:notice] = "Slide removed from slideshow"
      redirect_to edit_admin_slideshow_path(@slide.slideshow)
    end

    private

    def slide_params
      params.permit(slide: [:image_id, :title, :text, :slideshow_id, :position, :video_embed])[:slide]
    end

    def set_slideshow
      @slideshow = Slideshow.find(slideshow_id_param)
    end

    def set_slide
      @slide = Slide.find(id_param)
    end

    def slideshow_id_param
      params.permit(:slideshow_id)[:slideshow_id]
    end
  end
end
