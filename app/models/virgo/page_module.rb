module Virgo
  class PageModule < ActiveRecord::Base
    mount_uploader :image, Virgo::ImageUploader

    attr_accessor :subject_headline # form hook

    before_save :derive_template_path

    validates :name, presence: true

    belongs_to :subject, polymorphic: true

    has_many :page_module_posts, class_name: 'Virgo::PageModulePost'
    has_many :posts, through: :page_module_posts, class_name: 'Virgo::Post'

    scope :enabled, ->{ where(enabled: true) }

    scope :visible_to_admins, ->{ where(hidden_from_admins: false) }

    after_save :expire_site_key

    def self.POPULAR
      @_popular ||= find_by(name: 'popular posts')
    end

    def admin_image_path
      "virgo/admin/page_modules/#{name.downcase.gsub(' ', '_').gsub('-', '_')}.png"
    end

    def subject_headline
      subject.try :headline
    end

    private

    def derive_template_path(opts={})
      if name_changed? || opts[:force]
        self.template_path = "/virgo/page_modules/#{name.downcase.gsub(' ', '_').gsub('-', '_')}"
      end
    end
  end
end
