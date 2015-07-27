class RemoveImagesColFromSlides < ActiveRecord::Migration
  def change
    remove_column :platform_slides, :image
    rename_column :platform_slides, :image_rel_id, :image_id
  end
end
