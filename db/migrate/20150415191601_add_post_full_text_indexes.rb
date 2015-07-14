class AddPostFullTextIndexes < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;"
    add_column :platform_posts, :document, :text
    execute "CREATE INDEX posts_text_index ON posts USING gin (document gin_trgm_ops);"

    Post.all.each do |post|
      post.send :generate_search_document, force: true
      post.save!
    end
  end

  def down
    execute "DROP INDEX posts_text_index"
    remove_column :platform_posts, :document
  end
end
