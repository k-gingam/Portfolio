class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # フラッシュメッセージにBootstrapを適応
  add_flash_types :success, :info, :warning, :danger

  # ヘッダーに検索フォームを置かないといけない関係上、@qを常に宣言させておく為に必要
  before_action :set_search

  def set_search
    # フォームもしくはタグを使用して検索した際、検索ワードの抽出
    if params[:q].present?
      if params[:q][:comment_or_tags_name_cont].present?
        @search_ward = params[:q][:comment_or_tags_name_cont]
      elsif params[:q][:tags_name_eq].present?
        @search_ward = params[:q][:tags_name_eq]
      end
    end

    # Postテーブルから検索し、検索結果を@search_postsに渡す
    @q = Post.ransack(params[:q])
    @search_posts = @q.result(distinct: true).order(created_at: :desc)
  end
end
