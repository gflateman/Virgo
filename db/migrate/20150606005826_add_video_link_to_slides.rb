class AddVideoLinkToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :video_embed, :text
  end
end
