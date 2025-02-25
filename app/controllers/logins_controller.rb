class LoginsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    # 入力されたメールアドレスとパスワードを元にUserテーブル検索
    @user = login(params[:email], params[:password])

    # ログイン処理が出来たかどうか(Userテーブルからユーザー情報を取得できていれば)
    if @user.present?
      session[:user_id] = @user.id # Cookie保存用
      redirect_to root_path, success: t(".success_login")    # トップページに戻る
    else
      flash.now[:danger] = t(".error_login")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, info: t(".logout")
  end
end
