class MigrateSlideImagesToImagesModel < ActiveRecord::Migration
  def up
    add_column :slides, :image_rel_id, :integer, foreign_key: {references: :images}
    add_index :slides, :image_rel_id

    Slide.find_each do |slide|
      if slide.image.present?
        puts "migrating slide #{slide.id}"

        image = Image.new

        if Rails.env.development?
          image.remote_image_url = "http://localhost:3000" + slide.image.url
        else
          image.remote_image_url = slide.image.url
        end

        image.save!

        image.update_columns({created_at: slide.created_at, updated_at: slide.updated_at})

        slide.image_rel = image

        slide.save!
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
