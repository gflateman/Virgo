class AddParentIdToCategories < ActiveRecord::Migration
  def change
    add_column :virgo_categories, :parent_id, :integer
    add_index :virgo_categories, :parent_id
  end
end
