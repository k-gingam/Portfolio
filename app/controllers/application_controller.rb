class ApplicationController < ActionController::Base
  # ログイン専用ページに遷移しないようにする
  # before_action :require_login

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # フラッシュメッセージにBootstrapを適応
  add_flash_types :success, :info, :warning, :danger

  # ヘッダーに検索フォームを置かないといけない関係上、@qを常に宣言させておく為に必要
  before_action :set_search

  def set_search
    # フォームもしくはタグを使用して検索した際、検索ワードの抽出

    # Postテーブルから検索し、検索結果を@search_postsに渡す
    @q = Post.ransack(params[:q])
    @search_posts = @q.result(distinct: true).order(created_at: :desc)
  end

  private
  def not_authenticated
    redirect_to root_path, danger: "エラーが発生しました。"
  end
end
