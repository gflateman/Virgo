class AddMetadataToPosts < ActiveRecord::Migration
  def up
    enable_extension 'hstore' unless extension_enabled?('hstore')
    add_column :virgo_posts, :meta, :hstore
    Virgo::Post.find_each do |p|
      p.send :set_meta
      p.save
    end
  end

  def down
    remove_column :virgo_posts, :meta
  end
end
