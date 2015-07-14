class FeaturedImageUploader < ApplicationUploader
  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [301, 169]
  end

  version :med_thumb do
    process :resize_to_fill => [600, 337]
  end

  version :content do
    process :resize_to_limit => [800, 800]
  end

  version :featured do
    process :resize_to_limit => [1000, 800]
  end

  version :wide do
    process :resize_to_fill => [2000, 578]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
