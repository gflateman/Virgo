class MigrateSlideImagesToImagesModel < ActiveRecord::Migration
  def up
    add_column :platform_slides, :image_rel_id, :integer, foreign_key: {references: :platform_images}
    add_index :platform_slides, :image_rel_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
