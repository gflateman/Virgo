class RecreateSearchIndexOnPosts < ActiveRecord::Migration
  def up
    remove_column :platform_posts, :document

    add_column :platform_posts, :search_document, :text

    execute "CREATE INDEX post_search_document_index ON posts USING gin (search_document gin_trgm_ops);"

    Post.find_each do |post|
      post.send(:generate_search_document, force: true)
      post.save
    end
  end
end
