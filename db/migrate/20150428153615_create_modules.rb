class CreateModules < ActiveRecord::Migration
  def change
    create_table :platform_page_modules do |t|
      t.string :name
      t.string :template_path
      t.boolean :enabled
      t.integer :weight, default: 0
      t.timestamps
    end

    add_index :platform_page_modules, :enabled
    add_index :platform_page_modules, :weight
  end
end
