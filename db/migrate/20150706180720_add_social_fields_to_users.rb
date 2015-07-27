class AddSocialFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :platform_users, :twitter_id, :string
    add_column :platform_users, :facebook_id, :string
    add_column :platform_users, :instagram_id, :string
    add_column :platform_users, :pinterest_id, :string
    add_column :platform_users, :snapchat_id, :string
    add_column :platform_users, :linkedin_id, :string
    add_column :platform_users, :public_email, :string
  end
end
