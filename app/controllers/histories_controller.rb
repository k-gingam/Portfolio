class HistoriesController < ApplicationController
  # CSRFトークンを無視し、Ajaxでのリクエストを許可する
  skip_forgery_protection

  def create
    post_id = params[:post_id]
    history = History.find_by(user_id: current_user.id, post_id: post_id)

    if history.present?
      history.update(updated_at: Time.current)
    else
      history = History.create(user_id: current_user.id, post_id: post_id)
    end
  end
end
