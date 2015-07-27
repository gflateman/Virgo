module Platform
  class Admin::PostsController < Admin::BaseController
    before_action :set_post, only: member_actions(:revisions, :editing, :publish_immediately, :delete_featured_image)

    handles_sortable_columns

    helper_method :filter_params, :model_name, :post_params

    def index
      if sort_param.blank?
        flash.keep
        redirect_to admin_posts_path(filters: filter_params, sort: '-publish_at') and return
      end

      @posts = Post.with_relations
                   .search(filter_params)
                   .order(sort_order)
                   .page(page_param)
    end

    # auto-complete endpoint
    def find
      @posts = Post.search_by_similarity(term_param)

      render json: {
        posts: @posts
      }
    end

    def new
      @post = Post.new(post_params.merge(author: current_user))
    end

    def revision_detail
      @version = PaperTrail::Version.find(version_id_param)
      @post = @version.item
    end

    def revisions
    end

    def create
      @post = Post.new(post_params.merge(created_by: current_user))

      authorize! :manage, @post

      if @post.save
        flash[:notice] = "#{model_name} successfully created. You can edit it below."
        redirect_to edit_admin_post_path(@post)
      else
        render 'new'
      end
    end

    def show
    end

    def edit
      @post.attempt_edit_lock(current_user)
    end

    def author_dropdown
      @post = Post.find_by(id: post_id_param)

      render json: {
        html: render_content(partial: "author_dropdown")
      }
    end

    def update
      @post.attributes = post_params

      authorize! :manage, @post

      if Rails.application.config.post_locking_enabled
        if @post.is_mid_edit? && @post.editing_user && @post.editing_user != current_user
          flash.now[:warning] = "Could not save changes because post is currently being edited by #{@post.editing_user.pretty_name}"
          render and return
        end
      end

      if @post.save
        flash[:notice] = "Post saved"
        redirect_to edit_admin_post_path(@post)
      else
        render 'new'
      end
    end

    def destroy
      authorize! :destroy, @post

      @post.destroy

      flash[:notice] = "Post successfully deleted"

      redirect_to admin_posts_path
    end

    def editing
      if request.post?
        result = @post.attempt_edit_lock(current_user)

        render json: {
          edit_lock_succeeded: result,
          post_is_mid_edit: @post.is_mid_edit?,
          editor_is_self: (@post.editing_user == current_user),
          editor_byline: @post.editing_user.pretty_name
        }
      end
    end

    def delete_featured_image
      @post.update!(featured_image_id: nil)

      head :ok
    end

    def delete_thumbnail_image
      @post.update!(thumbnail_image_id: nil)

      head :ok
    end

    # Use with care (and perhaps only expose to admins):
    # In certain circumstances, such as when chasing breaking
    # news, we need to make immediate changes.
    def publish_immediately
      @post.update!(publish_at: Time.now, live: true)

      Rails.cache.clear
    end

    private

    def set_post
      @post = Post.friendly.find(id_param)
    end

    def post_params
      _post_params = params.permit(post: [:headline, :subhead, :excerpt, :author_id, :status, :slug, :post_type,
                           :publish_at, :body, :citation_name, :citation_url, :remove_featured_image, :column_id,
                           :title_tag_text, :meta_description_tag_value, :featured_image_id, :thumbnail_image_id,
                           :feature_on_front_page, :feature_on_category_page, :comments_enabled,
                           :show_feature_image_on_post_page, :show_excerpt, :include_in_weekly_email,
                           tag_ids: [], category_ids: [], ordered_tag_ids: []])[:post]

      _post_params[:publish_at] = Chronic.parse(_post_params[:publish_at]) if _post_params[:publish_at].present?

      _post_params
    end

    def post_id_param
      params.permit(:post_id)[:post_id]
    end

    def filter_params
      params.permit(filters: [:term, :post_type, :category, :month, :status, category_ids: [], tag_ids: [], user_ids: []])[:filters]
    end

    def version_id_param
      params.permit(:version_id)[:version_id]
    end

    def model_name
      @post.post_type.capitalize
    end

    def term_param
      params.permit(:term)[:term]
    end
  end
end
