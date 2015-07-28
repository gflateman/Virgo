module Virgo
  class AvatarUploader < Virgo::ApplicationUploader
    process resize_to_fill: [330, 330]

    version :thumb do
      process resize_to_fill: [120,120]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

    def default_url(*args)
      if version_name == :thumb
        '//placehold.it/120x120'
      else
        '//placehold.it/330x330'
      end
    end
  end
end
