class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    # 入力されたフォーム内容を元にUser型で宣言
    @user = User.new(user_params)

    # 新規登録の処理(フォームが正しく入力され、DBに保存できるか)
    if @user.save
      # 新規登録完了後、ログインページに戻る
      redirect_to new_login_path, success: t(".success_submit")
    else
      flash.now[:danger] = t(".error_submit")
      # Rails7で搭載されているTurbo対策用にstatusを設定、これがないとバリデーション失敗時のエラーが表示されない
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # ユーザーの削除処理
    user_id = session[:user_id]
    logout
    User.find_by(id: user_id).destroy
    redirect_to root_path, info: "退会しました。"
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      if !@user.after_change_email.nil?
        User.find_by(id: @user.id).update(email: @user.after_change_email, after_change_email: nil)
      end
      @user.activate!
      redirect_to root_path, success: "メール認証が成功しました。"
    else
      not_authenticated
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
