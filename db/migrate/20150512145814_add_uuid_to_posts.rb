class AddUuidToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :uuid, :string
    add_index :platform_posts, :uuid

    Post.find_each do |p|
      p.send :generate_uuid, force: true
      p.save
    end
  end
end
