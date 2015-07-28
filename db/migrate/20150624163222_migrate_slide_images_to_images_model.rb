class MigrateSlideImagesToImagesModel < ActiveRecord::Migration
  def up
    add_column :virgo_slides, :image_rel_id, :integer, foreign_key: {references: :virgo_images}
    add_index :virgo_slides, :image_rel_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
