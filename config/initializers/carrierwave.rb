require "carrierwave/storage/abstract"
require "carrierwave/storage/file"
require "carrierwave/storage/fog"

CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.storage = :file
  elsif Rails.env.production?
    config.storage :fog
    config.fog_directory  = "portfolio-omoro" # バケット名
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"], # 環境変数
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"], # 環境変数
      region: "ap-northeast-1", # リージョン
      path_style: true
    }
  end
end
