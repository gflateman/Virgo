if ['staging', 'production'].include?(Rails.env)
  CarrierWave.configure do |config|
    config.fog_directory  = Rails.application.secrets.s3_bucket
    config.storage = :fog
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_access_key
    }

    config.cache_dir = "#{Rails.root}/tmp/"
    config.asset_host = Rails.application.secrets.media_cdn_host
    config.fog_public     = true
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
  end
end

module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end
