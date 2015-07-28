class AddSlugsToCategoriesAndTags < ActiveRecord::Migration
  def change
    add_column :virgo_categories, :slug, :string
    add_column :virgo_tags, :slug, :string

    add_index :virgo_categories, :slug
    add_index :virgo_tags, :slug

    Virgo::Category.find_each(&:save)
    Virgo::Tag.find_each(&:save)
  end
end
