module Virgo
  class Admin::CategoriesController < Admin::BaseController
    before_action :set_category, only: member_actions

    handles_sortable_columns

    def index
      if params[:sort].nil?
        flash.keep
        redirect_to admin_categories_path(sort: 'navbar_weight') and return
      end

      @categories = Category.visible.order(sort_order).with_post_count.page(params[:page])
    end

    def new
      @category = Category.new
    end

    def modal_form
      @category = Category.new

      render json: {status: :success, html: render_content('modal_form', layout: false)}
    end

    def create
      @category = Category.new(category_params.merge(created_by: current_user))

      respond_to do |fmt|
        if @category.save
          fmt.json {
            @post = Post.find_by(id: params[:post_id])
            @post.categories << @category unless (@post.nil? || @post.categories.include?(@category))

            render json: {
              status: :success,
              html: render_content('success_modal', layout: false),
              categories_form_partial: render_content(partial: '/virgo/admin/posts/categories_form')}
          }
          fmt.html {
            flash[:notice] = "Category added successfully"
            redirect_to admin_categories_path
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
      if @category.update(category_params)
        flash[:notice] = "Category updated successfully"
        redirect_to admin_categories_path
      else
        render 'edit'
      end
    end

    def destroy
      @category.destroy

      flash[:notice] = "Category deleted"

      redirect_to admin_categories_path
    end

    private

    def set_category
      @category = Category.friendly.find(params[:id])
    end

    def category_params
      params.permit(category: [:name, :parent_id, :display_in_navbar, :navbar_weight, :slug])[:category]
    end
  end
end
