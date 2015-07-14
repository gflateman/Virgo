# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150714214759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "hstore"

  create_table "platform_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "slug"
    t.integer  "created_by_id"
    t.boolean  "display_in_navbar"
    t.integer  "navbar_weight",     default: 0
    t.boolean  "visible",           default: true
  end

  add_index "platform_categories", ["created_by_id"], name: "index_platform_categories_on_created_by_id", using: :btree
  add_index "platform_categories", ["display_in_navbar"], name: "index_platform_categories_on_display_in_navbar", using: :btree
  add_index "platform_categories", ["name"], name: "index_platform_categories_on_name", using: :btree
  add_index "platform_categories", ["navbar_weight"], name: "index_platform_categories_on_navbar_weight", using: :btree
  add_index "platform_categories", ["parent_id"], name: "index_platform_categories_on_parent_id", using: :btree
  add_index "platform_categories", ["slug"], name: "index_platform_categories_on_slug", using: :btree
  add_index "platform_categories", ["visible"], name: "index_platform_categories_on_visible", using: :btree

  create_table "platform_columns", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.string   "image"
    t.integer  "weight",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platform_columns", ["slug"], name: "index_platform_columns_on_slug", using: :btree
  add_index "platform_columns", ["weight"], name: "index_platform_columns_on_weight", using: :btree

  create_table "platform_images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "slug"
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

  add_index "platform_images", ["name"], name: "index_platform_images_on_name", using: :btree
  add_index "platform_images", ["slug"], name: "index_platform_images_on_slug", using: :btree
  add_index "platform_images", ["user_id"], name: "index_platform_images_on_user_id", using: :btree

  create_table "platform_page_module_posts", force: :cascade do |t|
    t.integer  "page_module_id"
    t.integer  "post_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platform_page_module_posts", ["page_module_id"], name: "index_platform_page_module_posts_on_page_module_id", using: :btree
  add_index "platform_page_module_posts", ["post_id"], name: "index_platform_page_module_posts_on_post_id", using: :btree

  create_table "platform_page_modules", force: :cascade do |t|
    t.string   "name"
    t.string   "template_path"
    t.boolean  "enabled"
    t.integer  "weight",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.boolean  "editable_subject",   default: false
    t.string   "image"
    t.boolean  "can_set_posts",      default: false
    t.boolean  "hidden_from_admins", default: false
  end

  add_index "platform_page_modules", ["enabled"], name: "index_platform_page_modules_on_enabled", using: :btree
  add_index "platform_page_modules", ["subject_id"], name: "index_platform_page_modules_on_subject_id", using: :btree
  add_index "platform_page_modules", ["subject_type"], name: "index_platform_page_modules_on_subject_type", using: :btree
  add_index "platform_page_modules", ["weight"], name: "index_platform_page_modules_on_weight", using: :btree

  create_table "platform_post_categories", force: :cascade do |t|
    t.integer "post_id"
    t.integer "category_id"
  end

  add_index "platform_post_categories", ["category_id"], name: "index_platform_post_categories_on_category_id", using: :btree
  add_index "platform_post_categories", ["post_id"], name: "index_platform_post_categories_on_post_id", using: :btree

  create_table "platform_post_tags", force: :cascade do |t|
    t.integer "post_id"
    t.integer "tag_id"
    t.integer "position", default: 0
  end

  add_index "platform_post_tags", ["position"], name: "index_platform_post_tags_on_position", using: :btree
  add_index "platform_post_tags", ["post_id"], name: "index_platform_post_tags_on_post_id", using: :btree
  add_index "platform_post_tags", ["tag_id"], name: "index_platform_post_tags_on_tag_id", using: :btree

  create_table "platform_posts", force: :cascade do |t|
    t.string   "post_type",                                                default: "post"
    t.string   "slug"
    t.integer  "author_id"
    t.text     "headline"
    t.text     "subhead"
    t.text     "excerpt"
    t.text     "body"
    t.string   "status",                                                   default: "draft"
    t.datetime "publish_at"
    t.boolean  "feature_on_front_page",                                    default: false
    t.boolean  "feature_on_category_page",                                 default: false
    t.boolean  "show_excerpt",                                             default: true
    t.text     "citation_name"
    t.text     "citation_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.string   "title_tag_text"
    t.text     "meta_description_tag_value"
    t.integer  "editing_user_id"
    t.datetime "editing_timestamp"
    t.boolean  "live",                                                     default: true
    t.integer  "view_count",                                               default: 0
    t.integer  "featured_image_id"
    t.text     "search_document"
    t.string   "uuid"
    t.integer  "column_id"
    t.boolean  "comments_enabled",                                         default: false
    t.boolean  "show_feature_image_on_post_page",                          default: true
    t.hstore   "meta"
    t.decimal  "popularity",                      precision: 12, scale: 3
    t.integer  "thumbnail_image_id"
  end

  add_index "platform_posts", ["author_id"], name: "index_platform_posts_on_author_id", using: :btree
  add_index "platform_posts", ["column_id"], name: "index_platform_posts_on_column_id", using: :btree
  add_index "platform_posts", ["created_by_id"], name: "index_platform_posts_on_created_by_id", using: :btree
  add_index "platform_posts", ["editing_timestamp"], name: "index_platform_posts_on_editing_timestamp", using: :btree
  add_index "platform_posts", ["editing_user_id"], name: "index_platform_posts_on_editing_user_id", using: :btree
  add_index "platform_posts", ["feature_on_category_page"], name: "index_platform_posts_on_feature_on_category_page", using: :btree
  add_index "platform_posts", ["feature_on_front_page"], name: "index_platform_posts_on_feature_on_front_page", using: :btree
  add_index "platform_posts", ["live"], name: "index_platform_posts_on_live", using: :btree
  add_index "platform_posts", ["popularity"], name: "index_platform_posts_on_popularity", using: :btree
  add_index "platform_posts", ["post_type"], name: "index_platform_posts_on_post_type", using: :btree
  add_index "platform_posts", ["publish_at"], name: "index_platform_posts_on_publish_at", using: :btree
  add_index "platform_posts", ["search_document"], name: "platform_post_search_document_index", using: :gin
  add_index "platform_posts", ["slug"], name: "index_platform_posts_on_slug", using: :btree
  add_index "platform_posts", ["status"], name: "index_platform_posts_on_status", using: :btree
  add_index "platform_posts", ["thumbnail_image_id"], name: "index_platform_posts_on_thumbnail_image_id", using: :btree
  add_index "platform_posts", ["updated_at"], name: "index_platform_posts_on_updated_at", using: :btree
  add_index "platform_posts", ["uuid"], name: "index_platform_posts_on_uuid", using: :btree
  add_index "platform_posts", ["view_count"], name: "index_platform_posts_on_view_count", using: :btree

  create_table "platform_sites", force: :cascade do |t|
    t.text     "tagline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "recommendations_enabled", default: true
  end

  create_table "platform_slides", force: :cascade do |t|
    t.text     "text"
    t.integer  "slideshow_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "video_embed"
    t.text     "title"
    t.integer  "image_id"
  end

  add_index "platform_slides", ["image_id"], name: "index_platform_slides_on_image_id", using: :btree
  add_index "platform_slides", ["position"], name: "index_platform_slides_on_position", using: :btree
  add_index "platform_slides", ["slideshow_id"], name: "index_platform_slides_on_slideshow_id", using: :btree

  create_table "platform_slideshows", force: :cascade do |t|
    t.integer  "author_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platform_slideshows", ["author_id"], name: "index_platform_slideshows_on_author_id", using: :btree

  create_table "platform_slug_histories", force: :cascade do |t|
    t.integer  "record_id"
    t.string   "record_type"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platform_slug_histories", ["record_id"], name: "index_platform_slug_histories_on_record_id", using: :btree
  add_index "platform_slug_histories", ["record_type"], name: "index_platform_slug_histories_on_record_type", using: :btree
  add_index "platform_slug_histories", ["slug"], name: "index_platform_slug_histories_on_slug", using: :btree

  create_table "platform_subscribers", force: :cascade do |t|
    t.string   "email"
    t.boolean  "subscribed", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platform_subscribers", ["email"], name: "index_platform_subscribers_on_email", using: :btree

  create_table "platform_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "created_by_id"
  end

  add_index "platform_tags", ["created_by_id"], name: "index_platform_tags_on_created_by_id", using: :btree
  add_index "platform_tags", ["name"], name: "index_platform_tags_on_name", using: :btree
  add_index "platform_tags", ["slug"], name: "index_platform_tags_on_slug", using: :btree

  create_table "platform_users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
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
    t.string   "role"
    t.string   "nickname"
    t.boolean  "canceled"
    t.string   "avatar"
    t.boolean  "active"
    t.boolean  "account_on_hold"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "byline"
    t.text     "about"
    t.string   "slug"
    t.boolean  "show_on_authors_page",   default: false
    t.integer  "author_page_weight",     default: 0
    t.string   "twitter_id"
    t.string   "facebook_id"
    t.string   "instagram_id"
    t.string   "pinterest_id"
    t.string   "snapchat_id"
    t.string   "linkedin_id"
    t.string   "public_email"
  end

  add_index "platform_users", ["author_page_weight"], name: "index_platform_users_on_author_page_weight", using: :btree
  add_index "platform_users", ["email"], name: "index_platform_users_on_email", using: :btree
  add_index "platform_users", ["role"], name: "index_platform_users_on_role", using: :btree
  add_index "platform_users", ["show_on_authors_page"], name: "index_platform_users_on_show_on_authors_page", using: :btree
  add_index "platform_users", ["slug"], name: "index_platform_users_on_slug", using: :btree
  add_index "platform_users", ["username"], name: "index_platform_users_on_username", using: :btree

  create_table "que_jobs", id: false, force: :cascade do |t|
    t.integer  "priority",    limit: 2, default: 100,                                        null: false
    t.datetime "run_at",                default: "now()",                                    null: false
    t.integer  "job_id",      limit: 8, default: "nextval('que_jobs_job_id_seq'::regclass)", null: false
    t.text     "job_class",                                                                  null: false
    t.json     "args",                  default: [],                                         null: false
    t.integer  "error_count",           default: 0,                                          null: false
    t.text     "last_error"
    t.text     "queue",                 default: "",                                         null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
