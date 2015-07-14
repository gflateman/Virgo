class AddSocialFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_id, :string
    add_column :users, :facebook_id, :string
    add_column :users, :instagram_id, :string
    add_column :users, :pinterest_id, :string
    add_column :users, :snapchat_id, :string
    add_column :users, :linkedin_id, :string
    add_column :users, :public_email, :string
  end
end
