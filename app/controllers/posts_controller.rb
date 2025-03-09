class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    # 入力されたフォーム内容を元にUser型で宣言
    @post = current_user.posts.new(post_params)
    tag_names = params[:post][:tag].split(",")

    # 新規登録の処理(フォームが正しく入力され、DBに保存できるか)
    if @post.save
      # タグの保存処理、"model/post"で処理を行う
      @post.save_tags(tag_names)
      # ポスト投稿完了後、トップページに戻る
      redirect_to root_path, success: t(".success_post")
    else
      flash.now[:danger] = t(".error_post")
      # Rails7で搭載されているTurbo対策用にstatusを設定、これがないとバリデーション失敗時のエラーが表示されない
      render :new, status: :unprocessable_entity
    end
  end

  def search
    if params[:q].present?
      if params[:q][:comment_or_tags_name_cont].present?
        @search_ward = params[:q][:comment_or_tags_name_cont]
      elsif params[:q][:tags_name_eq].present?
        @search_ward = params[:q][:tags_name_eq]
      end
    end
  end

  def destroy
    Post.find_by(id: params[:id]).destroy
    redirect_to profile_path(current_user.id), info: t(".delete.delete_post")
  end

  def multi
    # 入力された検索キーワードの内、部分一致したワード5つを取得して検索候補に表示
    @search_tags = Tag.where("name like ?", "%#{params[:q]}%").limit(5)
    respond_to do |format|
      format.js
    end
  end
  private

  def post_params
    params.require(:post).permit(:movie_url, :comment)
  end
end
