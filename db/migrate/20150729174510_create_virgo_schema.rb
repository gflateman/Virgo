class CreateVirgoSchema < ActiveRecord::Migration
  def change
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    enable_extension "pg_trgm"
    enable_extension "hstore"

    create_table "versions", force: :cascade do |t|
      t.string   "item_type",      null: false, index: {name: "index_versions_on_item_type_and_item_id", with: ["item_id"]}
      t.integer  "item_id",        null: false
      t.string   "event",          null: false
      t.string   "whodunnit"
      t.text     "object"
      t.datetime "created_at"
      t.text     "object_changes"
    end

    create_table "virgo_categories", force: :cascade do |t|
      t.string   "name",              index: {name: "index_virgo_categories_on_name"}
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "parent_id",         index: {name: "index_virgo_categories_on_parent_id"}
      t.string   "slug",              index: {name: "index_virgo_categories_on_slug"}
      t.integer  "created_by_id",     index: {name: "index_virgo_categories_on_created_by_id"}
      t.boolean  "display_in_navbar", index: {name: "index_virgo_categories_on_display_in_navbar"}
      t.integer  "navbar_weight",     default: 0, index: {name: "index_virgo_categories_on_navbar_weight"}
      t.boolean  "visible",           default: true, index: {name: "index_virgo_categories_on_visible"}
    end

    create_table "virgo_columns", force: :cascade do |t|
      t.string   "name"
      t.string   "slug",        index: {name: "index_virgo_columns_on_slug"}
      t.text     "description"
      t.string   "image"
      t.integer  "weight",      default: 0, index: {name: "index_virgo_columns_on_weight"}
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "virgo_images", force: :cascade do |t|
      t.integer  "user_id",           index: {name: "index_virgo_images_on_user_id"}
      t.string   "name",              index: {name: "index_virgo_images_on_name"}
      t.string   "slug",              index: {name: "index_virgo_images_on_slug"}
      t.string   "image"
      t.integer  "width"
      t.integer  "height"
      t.text     "data_file_name"
      t.text     "data_content_type"
      t.integer  "data_file_size"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "alt_text"
      t.text     "description"
      t.text     "credit"
    end

    create_table "virgo_page_module_posts", force: :cascade do |t|
      t.integer  "page_module_id", index: {name: "index_virgo_page_module_posts_on_page_module_id"}
      t.integer  "post_id",        index: {name: "index_virgo_page_module_posts_on_post_id"}
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "virgo_page_modules", force: :cascade do |t|
      t.string   "name"
      t.string   "template_path"
      t.boolean  "enabled",            index: {name: "index_virgo_page_modules_on_enabled"}
      t.integer  "weight",             default: 0, index: {name: "index_virgo_page_modules_on_weight"}
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "subject_id",         index: {name: "index_virgo_page_modules_on_subject_id"}
      t.string   "subject_type",       index: {name: "index_virgo_page_modules_on_subject_type"}
      t.boolean  "editable_subject",   default: false
      t.string   "image"
      t.boolean  "can_set_posts",      default: false
      t.boolean  "hidden_from_admins", default: false
    end

    create_table "virgo_post_categories", force: :cascade do |t|
      t.integer "post_id",     index: {name: "index_virgo_post_categories_on_post_id"}
      t.integer "category_id", index: {name: "index_virgo_post_categories_on_category_id"}
    end

    create_table "virgo_post_tags", force: :cascade do |t|
      t.integer "post_id",  index: {name: "index_virgo_post_tags_on_post_id"}
      t.integer "tag_id",   index: {name: "index_virgo_post_tags_on_tag_id"}
      t.integer "position", default: 0, index: {name: "index_virgo_post_tags_on_position"}
    end

    create_table "virgo_posts", force: :cascade do |t|
      t.string   "post_type",                       default: "post", index: {name: "index_virgo_posts_on_post_type"}
      t.string   "slug",                            index: {name: "index_virgo_posts_on_slug"}
      t.integer  "author_id",                       index: {name: "index_virgo_posts_on_author_id"}
      t.text     "headline"
      t.text     "subhead"
      t.text     "excerpt"
      t.text     "body"
      t.string   "status",                          default: "draft", index: {name: "index_virgo_posts_on_status"}
      t.datetime "publish_at",                      index: {name: "index_virgo_posts_on_publish_at"}
      t.boolean  "feature_on_front_page",           default: false, index: {name: "index_virgo_posts_on_feature_on_front_page"}
      t.boolean  "feature_on_category_page",        default: false, index: {name: "index_virgo_posts_on_feature_on_category_page"}
      t.boolean  "show_excerpt",                    default: true
      t.text     "citation_name"
      t.text     "citation_url"
      t.datetime "created_at"
      t.datetime "updated_at",                      index: {name: "index_virgo_posts_on_updated_at"}
      t.integer  "created_by_id",                   index: {name: "index_virgo_posts_on_created_by_id"}
      t.string   "title_tag_text"
      t.text     "meta_description_tag_value"
      t.integer  "editing_user_id",                 index: {name: "index_virgo_posts_on_editing_user_id"}
      t.datetime "editing_timestamp",               index: {name: "index_virgo_posts_on_editing_timestamp"}
      t.boolean  "live",                            default: true, index: {name: "index_virgo_posts_on_live"}
      t.integer  "view_count",                      default: 0, index: {name: "index_virgo_posts_on_view_count"}
      t.integer  "featured_image_id"
      t.text     "search_document",                 index: {name: "virgo_post_search_document_index", using: :gin, operator_class: "gin_trgm_ops"}
      t.string   "uuid",                            index: {name: "index_virgo_posts_on_uuid"}
      t.integer  "column_id",                       index: {name: "index_virgo_posts_on_column_id"}
      t.boolean  "comments_enabled",                default: false
      t.boolean  "show_feature_image_on_post_page", default: true
      t.hstore   "meta"
      t.decimal  "popularity",                      precision: 12, scale: 3, index: {name: "index_virgo_posts_on_popularity"}
      t.integer  "thumbnail_image_id",              index: {name: "index_virgo_posts_on_thumbnail_image_id"}
    end

    create_table "virgo_sites", force: :cascade do |t|
      t.text     "tagline"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "recommendations_enabled", default: true
      t.text     "name"
      t.text     "description"
      t.string   "disqus_app_id"
      t.string   "twitter_handle"
      t.string   "instagram_account_name"
      t.string   "pinterest_account_name"
    end

    create_table "virgo_slides", force: :cascade do |t|
      t.text     "text"
      t.integer  "slideshow_id", index: {name: "index_virgo_slides_on_slideshow_id"}
      t.integer  "position",     index: {name: "index_virgo_slides_on_position"}
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "video_embed"
      t.text     "title"
      t.integer  "image_id",     index: {name: "fk__virgo_slides_image_rel_id"}, foreign_key: {references: "virgo_images", name: "fk_virgo_slides_image_rel_id", on_update: :no_action, on_delete: :no_action}
    end
    add_index "virgo_slides", ["image_id"], name: "index_virgo_slides_on_image_id"

    create_table "virgo_slideshows", force: :cascade do |t|
      t.integer  "author_id",  index: {name: "index_virgo_slideshows_on_author_id"}
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "virgo_slug_histories", force: :cascade do |t|
      t.integer  "record_id",   index: {name: "index_virgo_slug_histories_on_record_id"}
      t.string   "record_type", index: {name: "index_virgo_slug_histories_on_record_type"}
      t.string   "slug",        index: {name: "index_virgo_slug_histories_on_slug"}
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "virgo_subscribers", force: :cascade do |t|
      t.string   "email",      index: {name: "index_virgo_subscribers_on_email"}
      t.boolean  "subscribed", default: true
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "virgo_tags", force: :cascade do |t|
      t.string   "name",          index: {name: "index_virgo_tags_on_name"}
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug",          index: {name: "index_virgo_tags_on_slug"}
      t.integer  "created_by_id", index: {name: "index_virgo_tags_on_created_by_id"}
    end

    create_table "virgo_users", force: :cascade do |t|
      t.string   "email",                  default: "",    null: false, index: {name: "index_virgo_users_on_email"}
      t.string   "encrypted_password",     default: "",    null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email"
      t.integer  "failed_attempts",        default: 0
      t.string   "unlock_token"
      t.datetime "locked_at"
      t.string   "authentication_token"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "role",                   index: {name: "index_virgo_users_on_role"}
      t.boolean  "canceled"
      t.string   "avatar"
      t.boolean  "active"
      t.boolean  "account_on_hold"
      t.string   "time_zone"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "username",               index: {name: "index_virgo_users_on_username"}
      t.string   "byline"
      t.text     "about"
      t.string   "slug",                   index: {name: "index_virgo_users_on_slug"}
      t.boolean  "show_on_authors_page",   default: false, index: {name: "index_virgo_users_on_show_on_authors_page"}
      t.integer  "author_page_weight",     default: 0, index: {name: "index_virgo_users_on_author_page_weight"}
      t.string   "twitter_id"
      t.string   "facebook_id"
      t.string   "instagram_id"
      t.string   "pinterest_id"
      t.string   "snapchat_id"
      t.string   "linkedin_id"
      t.string   "public_email"
    end
  end
end
