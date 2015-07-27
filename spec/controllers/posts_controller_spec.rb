require 'rails_helper'

describe Platform::PostsController do
  render_views
  routes { Platform::Engine.routes }

  # smoke test
  describe "index" do
    it "should not blow up" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "show" do
    it "should render for a live post" do
      @post = create(:post)

      get :show, id: @post.slug

      expect(response).to be_success
    end

    it "should redirect a request for a stale URI" do
      @post = create(:post)

      old_slug = @post.slug

      @post.update!(slug: "new-slug-#{Time.now.to_i}")

      get :show, id: old_slug

      expect(response).to redirect_to(post_detail_path(@post))
    end

    it "should display a 404 message if a post is not yet live" do
      @post = create(:post, live: false, publish_at: 1.day.from_now)

      get :show, id: @post.slug

      expect(response.status).to eq(404)
    end
  end
end
