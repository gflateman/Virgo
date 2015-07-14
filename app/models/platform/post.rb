module Platform
  class Post < ActiveRecord::Base
    paginates_per 10

    enable_redis_tracking

    has_paper_trail ignore: [:updated_at, :editing_user_id, :editing_timestamp, :live, :view_count, :meta, :popularity]

    include Post::Search, Post::Recommendations, ActionView::Helpers::SanitizeHelper, Common::Uuid, Common::SlugHistory

    extend FriendlyId

    attr_accessor :ordered_tag_ids

    friendly_id :slug_candidates, use: :slugged

    belongs_to :author, class_name: 'User'

    belongs_to :featured_image, class_name: 'Image'
    belongs_to :thumbnail_image, class_name: 'Image'

    belongs_to :created_by, class_name: 'User'

    belongs_to :editing_user, class_name: 'User'

    validates :author_id, presence: true

    has_many :post_tags, dependent: :destroy
    has_many :tags, through: :post_tags

    has_many :post_categories, dependent: :destroy
    has_many :categories, through: :post_categories

    belongs_to :column, touch: true

    validates :headline, presence: true, unless: :page?
    validates :body, presence: true

    validates :slug, presence: true, uniqueness: true

    symbolize :status
    symbolize :post_type

    scope :with_relations, ->{ joins(:author).preload(:author, :tags, :categories) }

    scope :publicly_viewable, ->{ where(status: :published, live: true).where.not(publish_at: nil) }
    scope :published, ->{ where(status: :published) }
    scope :draft, ->{ where(status: :draft) }
    scope :pages, ->{ where(post_type: :page) }
    scope :posts, ->{ where(post_type: :post) }
    scope :for_month, ->(month){ where("posts.publish_at >= :month_start AND posts.publish_at <= :month_end",
                                        month_start: month.beginning_of_month,
                                        month_end: month.end_of_month) }

    scope :for_weekly_email, ->{
      publicly_viewable.where(include_in_weekly_email: true)
    }

    scope :exclude_front_page_feature, ->{
      items = posts.publicly_viewable

      if Post.front_page_feature
        items = items.where.not(id: Post.front_page_feature.id)
      end

      items
    }

    scope :exclude_category_feature, ->(category){
      items = posts.publicly_viewable

      if Post.category_feature(category)
        items = items.where.not(id: Post.category_feature(category).id)
      end

      items
    }

    scope :exclude, ->(item) {
      if item.nil?
        all
      else
        where.not(id: item.id)
      end
    }

    scope :most_popular, ->{
      posts.publicly_viewable.order(popularity: :desc)
    }

    scope :latest, ->{ posts.publicly_viewable.order(publish_at: :desc) }

    scope :containing_slideshow, ->(slideshow){
      where("platform_posts.meta -> 'contains_slideshow' = 'true'").where("platform_posts.meta -> 'slideshow_id' = ?", slideshow.id.to_s)
    }

    before_save :set_default_publish_at
    before_save :set_live_status
    before_save :generate_search_document
    before_save :set_meta

    after_save :expire_site_key
    after_save :touch_dependent
    after_save :set_columns_category
    after_save :apply_tag_ordering!

    if Rails.application.config.require_posts_to_have_category
      validate :has_category
    end

    after_initialize :init

    def self.category_feature(category)
      category.posts.publicly_viewable.where(feature_on_category_page: true).order(publish_at: :asc).first
    end

    def self.front_page_feature
      posts.publicly_viewable.where(feature_on_front_page: true).order(publish_at: :asc).last
    end

    def permalink
      urls.post_detail_url(self, protocol: 'https')
    end

    def rendered_body
      @rendered_body ||= Shortcode.process(body || '').html_safe
    end

    def draft?
      status == :draft
    end

    def assigned?
      status == :assigned
    end

    def published?
      status == :published
    end

    def killed?
      status == :killed
    end

    def hidden?
      status == :hidden
    end

    def page?
      post_type == :page
    end

    def post?
      post_type == :post
    end

    def self.status_names
      {
        'Draft' => :draft,
        'Assigned' => :assigned,
        'Published' => :published,
        'Killed' => :killed,
        'Hidden' => :hidden
      }
    end

    def disqus_identifier
      "post_#{id}"
    end

    def self.publish_scheduled!
      candidates = Post.where.not(live: true).where("publish_at <= ?", Time.now.to_datetime)

      candidates.each do |post|
        post.update(live: true)
      end
    end

    def has_citation?
      citation_name.present? && citation_url.present?
    end

    # need to explicitly unscope this because papertrail
    # imposes a forward chronological order with a default scope
    def unscoped_versions
      PaperTrail::Version.unscoped.where(item_id: id)
    end

    # i.e. if the lock timeout is "15 seconds" but the post's
    # "editing_timestamp" has been bumped less than 15 seconds ago,
    # we say the post is "mid-edit"
    def is_mid_edit?
      editing_timestamp && editing_timestamp > edit_lock_timeout.ago
    end

    def lock_for_editing!(user)
      update!(editing_timestamp: Time.now.to_datetime, editing_user: user)
    end

    def attempt_edit_lock(user)
      if is_mid_edit? && editing_user != user
        false
      else
        lock_for_editing!(user) if persisted?
      end
    end

    def edit_lock_timeout
      Rails.application.config.edit_lock_timeout
    end

    def self.cache_key
      "posts-#{maximum(:updated_at).try(:to_i)}-#{all.size}"
    end

    def track_view!

      update_columns({
        view_count: (view_count + 1),
        popularity: calc_popularity(:increment)
      })
    end

    def calc_popularity(opt=nil)
      unless publish_at.nil?
        # the number of days ago the very oldest post was made
        days_ago_max = (Time.now - Post.minimum(:publish_at))/86400
        days_ago = (Time.now - publish_at)/86400

        # ex oldest post gets age_percentage 0.0, newest post gets 1.
        age_percentage = (1 - (days_ago/(days_ago_max || 1.0)))

        # boost from today to 10x...
        age_percentage = 10 if publish_at.to_date == Date.today

        # age factor is a number in the range of 0.1 - 1.00
        # that is used to moderate the weight of votes for this post
        age_factor = 0.1 + (0.9*age_percentage)

        basis = opt == :increment ? (view_count + 1) : view_count

        basis * age_factor
      else
        0
      end
    end

    def apply_tag_ordering!
      if ordered_tag_ids.present?
        if ordered_tag_ids.first.is_a?(String)
          cleaned = ordered_tag_ids.first.gsub("[", "").gsub("]", "").split(",").map(&:to_i)
          ordered_tag_ids = cleaned
        end

        ordered_tag_ids.each_with_index do |tag_id, index|
          existing = post_tags.find_by(tag_id: tag_id)

          if existing
            existing.update!(position: index)
          else
            tag = Tag.find_by(id: tag_id)

            if tag
              post_tags.create!(tag_id: tag_id, position: index)
            end
          end
        end

        post_tags.where.not(tag_id: ordered_tag_ids).map &:destroy
      end

      true
    end

    def primary_category
      categories.first
    end

    def description
      if meta_description_tag_value.present?
        meta_description_tag_value
      elsif excerpt.present?
        view_help.truncate(excerpt, length: 160)
      else
        view_help.truncate(view_help.strip_tags(rendered_body || ''), length: 160)
      end
    end

    def thumb_image
      if thumbnail_image.present?
        thumbnail_image
      else
        featured_image
      end
    end


    private

    def set_default_publish_at
      if status_changed? && status == :published && publish_at.blank?
        self.publish_at = Time.now.to_datetime
      end

      true
    end

    def init
      self.post_type = :post if post_type.nil?
    end

    def generate_search_document(opts={})
      if headline_changed? || body_changed? || author_id_changed? || excerpt_changed? || opts[:force]
        self.search_document = "#{headline} by #{author.byline}#{column ? (' ' + column.name) : ''}#{excerpt.present? ? (' ' + excerpt) : ''} #{strip_tags(rendered_body)}"
      end

      true
    end

    def set_meta
      self.meta = {} if (meta.nil? || meta.is_a?(String))

      # note: dirty tracking does not workin with hstore and meta_will_change! must be called
      # for changes to an existing hash to persist: https://github.com/rails/rails/issues/6127

      if has_slideshow?
        slideshow_id = body.match(/\[slideshow id=\"(?<slideshow_id>\d+)\"\]/)['slideshow_id']
        _will_change = (meta['contains_slideshow'] != 'true' || meta['slideshow_id'] != slideshow_id)
        self.meta['contains_slideshow'] = 'true'
        self.meta['slideshow_id'] = slideshow_id
        meta_will_change! if _will_change
      else
        _will_change = meta['contains_slideshow'] != 'false'
        self.meta['contains_slideshow'] = 'false'
        meta_will_change! if _will_change
      end

      true
    end

    def set_columns_category
      if column_id_changed?
        if column_id.present? && !categories.include?(Category.COLUMNS)
          self.categories << Category.COLUMNS
        elsif column_id.blank? && categories.include?(Category.COLUMNS)
          self.post_categories.where(category_id: Category.COLUMNS.id).map &:destroy
        end
      end

      true
    end

    def has_slideshow?
      body.present? && body.match(/\[slideshow id=\"\d+\"\]/).present?
    end

    def has_category
      if categories.size < 1 && post?
        errors[:base] << "Post must have at least one category"
      end
    end

    # if a post has a publish_at value set and it is
    # in the future, set the post to not be live
    def set_live_status
      if publish_at.present? && publish_at > Time.now.to_datetime
        self.live = false
      end

      true
    end

    def touch_dependent
      categories.map &:touch
    end

    def should_generate_new_friendly_id?
      slug.blank?
    end

    def slug_candidates
      [
        :headline,
        [:headline, :uuid],
        :uuid
      ]
    end
  end
end
