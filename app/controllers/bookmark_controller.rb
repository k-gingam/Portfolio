class BookmarkController < ApplicationController
  # フォローボタンが押された時の処理
  def bookmark
    current_user.game_bookmark(params[:id], current_user.id)
    redirect_to game_path(params[:id])
  end
  # フォロー解除ボタンが押された時の処理
  def unbookmark
    current_user.game_unbookmark(params[:id], current_user.id)
    redirect_to game_path(params[:id])
  end
end
