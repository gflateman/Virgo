class CreateSite < ActiveRecord::Migration
  def change
    create_table :virgo_sites do |t|
      t.text :tagline
      t.timestamps
    end
  end
end
