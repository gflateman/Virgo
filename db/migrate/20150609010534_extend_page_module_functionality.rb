class ExtendPageModuleFunctionality < ActiveRecord::Migration
  def up
    begin
      add_column :platform_page_modules, :image, :string
      add_column :platform_page_modules, :can_set_posts, :boolean, default: false
      create_table :platform_page_module_posts do |t|
        t.integer :page_module_id
        t.integer :post_id
        t.integer :position
        t.timestamps
      end
      add_index :platform_page_module_posts, :page_module_id
      add_index :platform_page_module_posts, :post_id
    rescue NoMethodError
      puts "swallowed NoMethodError in migration AddColumnPageModule"
    end
  end

  def down
    drop_table :platform_page_module_posts
    remove_column :platform_page_modules, :image
    remove_column :platform_page_modules, :can_set_posts
  end
end
