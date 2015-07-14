class CreateColumnsCategory < ActiveRecord::Migration
  def up
    if Category.where(name: "Columns").empty?
      Category.create!(name: "Columns")
    end

    Post.find_each do |post|
      post.send :set_columns_category
      post.save
    end
  end
end
