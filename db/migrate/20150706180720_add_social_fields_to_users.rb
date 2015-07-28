class AddSocialFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :virgo_users, :twitter_id, :string
    add_column :virgo_users, :facebook_id, :string
    add_column :virgo_users, :instagram_id, :string
    add_column :virgo_users, :pinterest_id, :string
    add_column :virgo_users, :snapchat_id, :string
    add_column :virgo_users, :linkedin_id, :string
    add_column :virgo_users, :public_email, :string
  end
end
