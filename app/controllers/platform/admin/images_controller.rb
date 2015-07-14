module Platform
  class Admin::ImagesController < Admin::BaseController
    before_action :set_image, only: member_actions(:embed)

    handles_sortable_columns

    def index
      @images = Image.all.search(filter_params).order(sort_order).page(page_param).per(40)
    end

    def new
      @image = Image.new
    end

    def create
      @image = Image.new(image_params.merge(user: current_user))

      if @image.save
        flash[:notice] = "Image uploaded successfully"
        redirect_to edit_admin_image_path(@image)
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @image.update(image_params)
        flash[:notice] = "Image properties updated successfully"
        redirect_to edit_admin_image_path(@image)
      else
        render :new
      end
    end

    def destroy
      @image.destroy

      flash[:notice] = "Image successfully deleted"

      redirect_to admin_images_path
    end

    def upload
      @image = Image.new

      file = params[:file]

      @image.image = UploadHelpers::Http.normalize_param(file, request)

      @image.user = current_user

      if @image.save
        render :text => { :filelink => @image.image.url }.to_json
      else
        render json: { error: @image.errors }
      end
    end

    def embed
      render json: {
        html: compact_html(Shortcode.process(render_to_string(partial: "/platform/images/shortcode", locals: {image: @image})))
      }
    end

    private

    def set_image
      @image = Image.friendly.find(id_param)
    end

    def image_params
      params.permit(image: [:name, :image, :alt_text, :description, :credit])[:image]
    end

    def self.normalize_param(*args)
      value = args.first
      if Hash === value && value.has_key?(:tempfile)
        UploadedFile.new(value)
      elsif value.is_a?(String)
        QqFile.new(*args)
      else
        value
      end
    end
  end
end
