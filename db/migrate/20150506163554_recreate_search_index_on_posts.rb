class RecreateSearchIndexOnPosts < ActiveRecord::Migration
  def up
    remove_column :virgo_posts, :document

    add_column :virgo_posts, :search_document, :text

    execute "CREATE INDEX virgo_post_search_document_index ON virgo_posts USING gin (search_document gin_trgm_ops);"

    Virgo::Post.find_each do |post|
      post.send(:generate_search_document, force: true)
      post.save
    end
  end
end
