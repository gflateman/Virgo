class RemoveImagesColFromSlides < ActiveRecord::Migration
  def change
    remove_column :virgo_slides, :image
    rename_column :virgo_slides, :image_rel_id, :image_id
  end
end
