source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.0"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire"s SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire"s modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# ------ここから自分で記載したgem一覧------
# 画像ファイルアップロード機能の追加
gem "carrierwave", "~> 2.0"

# ファイルサーバAWS S3アップロード用のGem
gem "aws-sdk-s3", require: false

# ファイルサーバAWS S3の操作コード用
gem "fog-aws"

# Lintチェック用
gem "rubocop", require: false

# ログイン機能用
gem "sorcery"

# パスワードリセットのテスト用サイトを設定
gem "letter_opener", group: :development
gem "config"

# i18n設定用
gem "rails-i18n", "~> 7.0.0"

# CSSフレームワークのBootstrap5をインストール
gem "bootstrap", "~> 5.2.0"

# JavaScript実行に必要なランタイム用
gem "mini_racer"
# ------ここまで-----------------------------

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # ------ここから自分で記載したgem一覧------
  # パスワードリセットのテスト用
  gem "letter_opener_web"
  # ------ここまで-----------------------------
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
