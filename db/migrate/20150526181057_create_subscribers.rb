class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :virgo_subscribers do |t|
      t.string :email
      t.boolean :subscribed, default: true
      t.timestamps
    end

    add_index :virgo_subscribers, :email
  end
end
