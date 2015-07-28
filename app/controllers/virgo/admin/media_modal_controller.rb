module Virgo
  class Admin::MediaModalController < Admin::BaseController
    before_action :set_images, only: [:index, :library_panel]

    before_action :set_image, only: [:image_settings]

    helper_method :last_page?, :next_page_num, :caption_param

    def index
      render json: {
        html: render_content(layout: false)
      }
    end

    def library_panel
      render json: {
        html: render_content(partial: 'library_panel'),
        is_last_page: last_page?
      }
    end

    def upload_panel
      if request.post?
        @image = Image.new(image_params.merge(user: current_user))

        if @image.save
          render json: {
            status: 'upload_success',
            html: render_content(partial: 'upload_success'),
            image: @image,
            img_url: @image.image.url(:content),
            image_html: compact_html(Shortcode.process(render_to_string(partial: "/virgo/images/shortcode", locals: {image: @image})))
          } and return
        end
      else
        @image = Image.new
      end

      render json: {
        html: render_content(partial: 'upload_panel')
      }
    end

    def image_settings
      if request.get?
        render json: {
          html: render_content(partial: 'image_settings')
        }
      elsif request.patch?
        if @image.update(image_params)
          render json: {
            status: :success,
            image: @image,
            caption: caption_param,
            credit: @image.credit,
            html: compact_html(Shortcode.process(render_to_string(partial: "/virgo/images/shortcode", locals: {image: @image})))
          }
        else
          render json: {
            status: :err,
            html: render_content(partial: 'image_settings')
          }
        end
      end
    end

    private

    def set_images
      @images = Image.order(created_at: :desc).page(page_param).per(32)
    end

    def image_params
      params.permit(image: [:name, :image, :alt_text, :description, :credit])[:image]
    end

    def last_page?
      @images && (page_param.present? ? page_param.to_i : (page_param.to_i + 1)) >= @images.total_pages
    end

    def next_page_num
      page_param.present? ? (page_param.to_i + 1) : 2
    end

    def set_image
      @image = Image.friendly.find(image_id_param)
    end

    def image_id_param
      params.permit(:image_id)[:image_id]
    end

    def caption_param
      _caption = params.permit(:caption)[:caption]

      _caption = _caption.gsub("%0A", "") if _caption.present?

      URI.decode(_caption) if _caption.present?
    end
  end
end
