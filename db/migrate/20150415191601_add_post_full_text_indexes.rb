class AddPostFullTextIndexes < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;"
    add_column :virgo_posts, :document, :text
    execute "CREATE INDEX virgo_posts_text_index ON virgo_posts USING gin (document gin_trgm_ops);"

    Virgo::Post.all.each do |post|
      post.send :generate_search_document, force: true
      post.save!
    end
  end

  def down
    execute "DROP INDEX virgo_posts_text_index"
    remove_column :virgo_posts, :document
  end
end
