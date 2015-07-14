class AddParentIdToCategories < ActiveRecord::Migration
  def change
    add_column :platform_categories, :parent_id, :integer
    add_index :platform_categories, :parent_id
  end
end
