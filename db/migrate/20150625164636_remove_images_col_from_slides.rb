class RemoveImagesColFromSlides < ActiveRecord::Migration
  def change
    remove_column :slides, :image
    rename_column :slides, :image_rel_id, :image_id
  end
end
