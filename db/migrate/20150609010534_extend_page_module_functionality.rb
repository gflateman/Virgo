class ExtendPageModuleFunctionality < ActiveRecord::Migration
  def up
    begin
      add_column :virgo_page_modules, :image, :string
      add_column :virgo_page_modules, :can_set_posts, :boolean, default: false
      create_table :virgo_page_module_posts do |t|
        t.integer :page_module_id
        t.integer :post_id
        t.integer :position
        t.timestamps
      end
      add_index :virgo_page_module_posts, :page_module_id
      add_index :virgo_page_module_posts, :post_id
    rescue NoMethodError
      puts "swallowed NoMethodError in migration AddColumnPageModule"
    end
  end

  def down
    drop_table :virgo_page_module_posts
    remove_column :virgo_page_modules, :image
    remove_column :virgo_page_modules, :can_set_posts
  end
end
