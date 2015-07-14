class CreateSite < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.text :tagline
      t.timestamps
    end
  end
end
