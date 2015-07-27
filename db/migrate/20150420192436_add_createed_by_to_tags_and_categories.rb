class AddCreateedByToTagsAndCategories < ActiveRecord::Migration
  def change
    add_column :platform_tags, :created_by_id, :integer
    add_column :platform_categories, :created_by_id, :integer
    add_index :platform_tags, :created_by_id
    add_index :platform_categories, :created_by_id
  end
end
