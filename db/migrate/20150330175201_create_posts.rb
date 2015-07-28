class CreatePosts < ActiveRecord::Migration
  def change
    create_table :virgo_posts do |t|
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
    add_index :virgo_posts, :author_id
    add_index :virgo_posts, :created_by
    add_index :virgo_posts, :publish_at
    add_index :virgo_posts, :post_type
    add_index :virgo_posts, :slug
    add_index :virgo_posts, :status
    add_index :virgo_posts, :feature_on_front_page
    add_index :virgo_posts, :feature_on_category_page

    create_table :virgo_categories do |t|
    t.string :name
      t.timestamps
    end

    add_index :virgo_categories, :name

    create_table :virgo_post_categories do |t|
      t.integer :post_id
      t.integer :category_id
    end

    add_index :virgo_post_categories, :post_id
    add_index :virgo_post_categories, :category_id

    create_table :virgo_tags do |t|
      t.string :name
      t.timestamps
    end

    add_index :virgo_tags, :name

    create_table :virgo_post_tags do |t|
      t.integer :post_id
      t.integer :tag_id
    end

    add_index :virgo_post_tags, :post_id
    add_index :virgo_post_tags, :tag_id
  end
end
