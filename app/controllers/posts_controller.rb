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

  def destroy
    Post.find_by(id: params[:id]).destroy
    redirect_to profile_path(current_user.id), info: t(".delete.delete_post")
  end

  private

  def post_params
    params.require(:post).permit(:movie_url, :comment)
  end
end
