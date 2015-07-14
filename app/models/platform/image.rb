module Platform
  class Image < ActiveRecord::Base
    extend FriendlyId

    friendly_id :name, use: :slugged

    mount_uploader :image, ImageUploader

    validates :name, presence: true
    validates :image, presence: true

    belongs_to :user

    before_validation :derive_name

    scope :search, ->(filters={}){
      items = all

      if filters[:term].present?
        items = items.where("images.name ILIKE :term", term: "%#{filters[:term]}%")
      end

      items
    }

    def url(arg)
      image.url
    end

    def redactor_json
      {
        thumb: image.url(:thumb),
        image: image.url
      }
    end

    def as_json(opts={})
      {
        id: id,
        name: name,
        alt_text: alt_text,
        credit: credit,
        description: description,
        slug: slug,
        image_url: image.try(:url),
        small_thumb_image: image.try(:url, :small_thumb),
        thumb_image: image.try(:url, :thumb),
        med_thumb_image: image.try(:url, :med_thumb),
        content_image: image.try(:url, :content),
        featured_image: image.try(:url, :featured),
        wide_image: image.try(:url, :wide)
      }
    end

    private

    def derive_name
      if defined?(image_changed?) && image_changed? && !name_changed? && name.blank?
        self.name = image.file.try(:filename)
      end
    end
  end
end
