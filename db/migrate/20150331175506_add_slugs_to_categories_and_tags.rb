class AddSlugsToCategoriesAndTags < ActiveRecord::Migration
  def change
    add_column :platform_categories, :slug, :string
    add_column :platform_tags, :slug, :string

    add_index :platform_categories, :slug
    add_index :platform_tags, :slug

    Platform::Category.find_each(&:save)
    Platform::Tag.find_each(&:save)
  end
end
