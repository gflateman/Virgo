class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :platform_subscribers do |t|
      t.string :email
      t.boolean :subscribed, default: true
      t.timestamps
    end

    add_index :platform_subscribers, :email
  end
end
