module Virgo
  class PostsController < ApplicationController
    before_action :enable_large_nav, only: [:index]

    if Rails.application.config.caching == :aggressive
      caches_action :show, if: ->{ current_user.nil? && flash.empty? },
                    cache_path: ->(o){ "#{deploy_key}/#{site_key}/posts/#{params[:category_id]}/#{params[:id]}/#{post_timestamp(params[:id])}" }

      caches_action :index, if: ->{ current_user.nil? && flash.empty? },
                    cache_path: ->(o){ "#{deploy_key}/#{site_key}/posts/index/#{params[:page]}" }

      caches_action :latest, if: ->{ current_user.nil? && flash.empty? },
                    cache_path: ->(o){ "#{deploy_key}/#{site_key}/posts/latest/#{params[:page]}" }
    end

    def index
      @posts = Post.posts.publicly_viewable.order(publish_at: :desc).page(params[:page])
    end

    def more
      @posts = Post.order(publish_at: :desc).page(params[:page]).per(6).padding(6)
      render json: {
        html: render_content('/virgo/posts/more', layout: false)
      }
    end

    def latest
      @posts = Post.posts.publicly_viewable.order(publish_at: :desc).page(params[:page])
    end

    def show
      # call this in the action so it doesn't run before the action cache wrapper
      set_post

      if old_path?
        redirect_to(post_detail_path(@post), status: :moved_permanently) and return
      end

      if @post.page?
        @page = @post
        render "/virgo/pages/show", layout: "virgo/application"
      else
        render layout: '/virgo/posts'
      end
    end

    def popular
      render json: {html: render_content(partial: "/virgo/page_modules/popular_posts")}
    end

    def rss
      @limit = Rails.env.production? ? 50 : 5

      render 'rss.xml', layout: false, content_type: Mime::XML
    end

    def track
      # note: we keep a transient/compact hash record of recent tracks in a hash
      # in memcached to prevent abuse of this endpoint (i.e. the same user
      # can't slam this endpoint w/ js ajax requests to artificially pump up a story)
      tracked = JSON::load(Rails.cache.fetch("tracks[#{client_id}]") || '{}')

      unless tracked[params[:id]]
        set_post
        @post.track_view!
        tracked[@post.id.to_s] = 1
        Rails.cache.write("tracks[#{client_id}]", JSON::dump(tracked))
      end

      head :ok
    end

    private

    def set_post
      # there have been instances where url shorteners append querystring
      # params w/ a leading "&" instead of w/ a leading "?"
      # (assuming there are alread querystring params on the
      # article url I guess) - adding a catch for this here.
      post_id = params[:id]

      post_id = (post_id.present? && post_id.include?("&")) ? post_id.slice(0..(post_id.index('&') - 1)) : post_id

      @post = Post.find_by_id_or_historic_slug!(post_id)

      if params[:category_id].present?
        @category = Category.friendly.find(params[:category_id])
      else
        @category = @post.primary_category
      end

      authorize! :read, @post
    end

    def old_path?
      if @post && params[:id] != @post.slug && params[:id].to_i != @post.id
        true
      end
    end
  end
end
