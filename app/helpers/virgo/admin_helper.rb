module Virgo
  module AdminHelper
    # because pages and posts are actually both "Post" records, we need
    # to use a couple hints to establish whether we're on
    # a posts page or a pages page
    def pages_action?
      params[:filters][:post_type] == 'page' ||
        @post && @post.page?
    end

    def posts_action?
      (params[:filters][:post_type].blank? || params[:filters][:post_type] == 'post') && (@post.nil? || @post.post?)
    end
  end
end
