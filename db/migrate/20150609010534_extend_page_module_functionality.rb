class ExtendPageModuleFunctionality < ActiveRecord::Migration
  def up
    begin
      add_column :page_modules, :image, :string
      add_column :page_modules, :can_set_posts, :boolean, default: false
      create_table :page_module_posts do |t|
        t.integer :page_module_id
        t.integer :post_id
        t.integer :position
        t.timestamps
      end
      add_index :page_module_posts, :page_module_id
      add_index :page_module_posts, :post_id

      tag_module = PageModule.find_by(name: "Tag Focus")
      tag_module.update! can_set_posts: true, editable_subject: true
    rescue NoMethodError
      puts "swallowed NoMethodError in migration AddColumnPageModule"
    end
  end

  def down
    drop_table :page_module_posts
    remove_column :page_modules, :image
    remove_column :page_modules, :can_set_posts
  end
end
