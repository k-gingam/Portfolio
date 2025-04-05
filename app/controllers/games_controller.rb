class GamesController < ApplicationController
  def list
    # テーブルGameに格納されているゲーム情報を取得
    @games = Game.all.order(created_at: :desc)
  end

  def show
    # 指定されたゲームの情報を取得
    @game = Game.find(params[:id])
    # 指定されたゲームに関連するポストを内部結合して取得
    @game_posts = Post.joins(:post_games).select("posts.*, post_games.game_id").where(post_games: { game_id: @game.id }).order(created_at: :desc)
  end
end
