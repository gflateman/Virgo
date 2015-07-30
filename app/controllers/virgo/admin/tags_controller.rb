module Virgo
  class Admin::TagsController < Admin::BaseController
    before_action :set_tag, only: member_actions

    handles_sortable_columns

    def index
      if params[:sort].blank? && filter_params.all_blank?
        flash.keep
        redirect_to admin_tags_path(sort: 'name') and return
      end

      @tags = Tag.search(filter_params).with_post_count.order(sort_order).page(params[:page])
    end

    def new
      @tag = Tag.new
    end

    def modal_form
      @tag = Tag.new

      render json: {status: :success, html: render_content('modal_form', layout: false)}
    end

    def create
      @tag = Tag.new(tag_params.merge(created_by: current_user))

      respond_to do |fmt|
        if @tag.save
          fmt.json {
            @post = Post.find_by(id: params[:post_id])
            @post.tags << @tag unless (@post.nil? || @post.tags.include?(@tag))

            flash.now[:success] = "Tag successfully added! If you would like to add more tags you can do so below. Otherwise, close this pop-up."

            render json: {
              status: :success,
              tag: @tag,
              html: render_content('modal_form', layout: false, locals: {tag: Tag.new})
            }
          }
          fmt.html {
            flash[:notice] = "Tag added successfully"
            redirect_to admin_tags_path
          }
        else
          fmt.json {
            render json: {status: :err, html: render_content('modal_form', layout: false)}
          }
          fmt.html {
            render 'new'
          }
        end
      end

    end

    def edit
    end

    def update
      if @tag.update(tag_params)
        flash[:notice] = "Tag updated successfully"
        redirect_to admin_tags_path
      else
        render 'edit'
      end
    end

    def destroy
      @tag.destroy

      flash[:notice] = "Tag deleted"

      redirect_to admin_tags_path
    end

    private

    def set_tag
      @tag = Tag.friendly.find(params[:id])
    end

    def tag_params
      params.permit(tag: [:name])[:tag]
    end

    def filter_params
      params.permit(filters: [:term])[:filters]
    end
  end
end
