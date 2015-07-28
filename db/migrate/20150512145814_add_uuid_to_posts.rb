class AddUuidToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :uuid, :string
    add_index :virgo_posts, :uuid

    Virgo::Post.find_each do |p|
      p.send :generate_uuid, force: true
      p.save
    end
  end
end
