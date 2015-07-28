module Virgo
  class Slide < ActiveRecord::Base
    belongs_to :slideshow, touch: true
    belongs_to :image

    scope :by_position, ->{ order(position: :asc) }

    # validation disabled on editors' request
    # validate :has_video_or_image

    def video?
      video_embed.present?
    end

    private

    def has_video_or_image
      if video_embed.blank? && image.blank?
        errors[:base] << "Slide must include either a video embed or an image attachment."
      end
    end
  end
end
