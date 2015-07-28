class AddAuthorPageAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :virgo_users, :show_on_authors_page, :boolean, default: false
    add_index :virgo_users, :show_on_authors_page
    add_column :virgo_users, :author_page_weight, :integer, default: 0
    add_index :virgo_users, :author_page_weight
  end
end
