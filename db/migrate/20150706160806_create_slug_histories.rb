class CreateSlugHistories < ActiveRecord::Migration
  def change
    create_table :platform_slug_histories do |t|
      t.integer :record_id
      t.string :record_type
      t.string :slug
      t.timestamps
    end

    add_index :platform_slug_histories, :record_id
    add_index :platform_slug_histories, :record_type
    add_index :platform_slug_histories, :slug
  end
end
