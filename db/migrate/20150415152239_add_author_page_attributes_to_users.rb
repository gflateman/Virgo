class AddAuthorPageAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :platform_users, :show_on_authors_page, :boolean, default: false
    add_index :platform_users, :show_on_authors_page
    add_column :platform_users, :author_page_weight, :integer, default: 0
    add_index :platform_users, :author_page_weight
  end
end
