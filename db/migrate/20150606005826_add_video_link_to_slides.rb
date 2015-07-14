class AddVideoLinkToSlides < ActiveRecord::Migration
  def change
    add_column :platform_slides, :video_embed, :text
  end
end
