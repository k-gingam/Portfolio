class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # フラッシュメッセージにBootstrapを適応
  add_flash_types :success, :info, :warning, :danger
end
