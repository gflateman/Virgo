module Virgo
  class SlideUploader < Virgo::ApplicationUploader
    version :med_thumb do
      process :resize_to_fill => [500, 500]
    end

    version :content do
      process :resize_to_limit => [800, 800]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

    def store_dir
      "uploads/#{model.class.to_s.underscore}/image/#{model.id}"
    end
  end
end
