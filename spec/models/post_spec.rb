require 'rails_helper'

describe Platform::Post do
  describe "#publish_scheduled!" do
    it "should set a non-live post to live if it has status=published and its publish_at date is in the past" do
      @post = create(:post, status: :published, publish_at: 1.day.from_now)

      expect(@post.live).to be false

      @post.update!(publish_at: 1.day.ago)

      @post.update_column :live, false

      expect(@post.live).to be false

      Platform::Post.publish_scheduled!

      @post.reload

      expect(@post.live).to be true
    end
  end

  describe "#front_page_feature" do
    it "should surface the most recent post marked as front page feature" do
      @most_recent = create(:post, publish_at: 1.minute.ago, feature_on_front_page: true)
      @next_most_recent = create(:post, publish_at: 5.minutes.ago, feature_on_front_page: true)

      expect(Platform::Post.front_page_feature).to eq @most_recent

      expect(Platform::Post.exclude_front_page_feature).to_not include @most_recent
    end
  end

  describe "#category_page_feature" do
    it "should surface the most recent post marked as category page feature" do
      @most_recent = create(:post, publish_at: 1.minute.ago, feature_on_category_page: true)
      @next_most_recent = create(:post, publish_at: 5.minutes.ago, feature_on_category_page: true)
      @category = create(:category)

      @most_recent.categories << @category
      @next_most_recent.categories << @category

      expect(Platform::Post.category_feature(@category)).to eq @most_recent

      expect(Platform::Post.exclude_category_feature(@category)).to_not include @most_recent
    end
  end
end
