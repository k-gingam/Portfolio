class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    # 入力されたフォーム内容を元にUser型で宣言
    @user = User.new(user_params)

    # 新規登録の処理(フォームが正しく入力され、DBに保存できるか)
    if @user.save
      # 新規登録完了後、トップページに戻る
      redirect_to root_path, notice: "新規登録が完了しました"
    else
      flash.now[:alert] = "登録に失敗しました"
      # Rails7で搭載されているTurbo対策用にstatusを設定、これがないとバリデーション失敗時のエラーが表示されない
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
