class AddVideoLinkToSlides < ActiveRecord::Migration
  def change
    add_column :virgo_slides, :video_embed, :text
  end
end
