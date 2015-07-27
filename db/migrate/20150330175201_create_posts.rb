class CreatePosts < ActiveRecord::Migration
  def change
    create_table :platform_posts do |t|
      t.string :post_type, default: 'post'
      t.string :slug
      t.integer :author_id
      t.integer :created_by
      t.text :headline
      t.text :subhead
      t.text :excerpt
      t.text :body
      t.string :status, default: 'draft'
      t.datetime :publish_at
      t.boolean :feature_on_front_page, default: false
      t.boolean :feature_on_category_page, default: false
      t.boolean :show_excerpt, default: true
      t.text :citation_name
      t.text :citation_url
      t.timestamps
    end
    add_index :platform_posts, :author_id
    add_index :platform_posts, :created_by
    add_index :platform_posts, :publish_at
    add_index :platform_posts, :post_type
    add_index :platform_posts, :slug
    add_index :platform_posts, :status
    add_index :platform_posts, :feature_on_front_page
    add_index :platform_posts, :feature_on_category_page

    create_table :platform_categories do |t|
    t.string :name
      t.timestamps
    end

    add_index :platform_categories, :name

    create_table :platform_post_categories do |t|
      t.integer :post_id
      t.integer :category_id
    end

    add_index :platform_post_categories, :post_id
    add_index :platform_post_categories, :category_id

    create_table :platform_tags do |t|
      t.string :name
      t.timestamps
    end

    add_index :platform_tags, :name

    create_table :platform_post_tags do |t|
      t.integer :post_id
      t.integer :tag_id
    end

    add_index :platform_post_tags, :post_id
    add_index :platform_post_tags, :tag_id
  end
end
