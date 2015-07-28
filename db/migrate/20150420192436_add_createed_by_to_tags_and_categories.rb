class AddCreateedByToTagsAndCategories < ActiveRecord::Migration
  def change
    add_column :virgo_tags, :created_by_id, :integer
    add_column :virgo_categories, :created_by_id, :integer
    add_index :virgo_tags, :created_by_id
    add_index :virgo_categories, :created_by_id
  end
end
