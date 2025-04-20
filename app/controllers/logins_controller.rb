class LoginsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    # 入力したユーザーが存在するか
    if User.where(email: params[:email]).exists?
      # メールアドレス変更の認証がまだ行ってない状態でログインした場合、認証を無効にしてログインできるように救済措置を行う
      if !User.find_by(email: params[:email]).after_change_email.nil?
        user = User.find_by(email: params[:email])
        user.change_email_rescue(params[:email])
      end
    end

    # 入力されたメールアドレスとパスワードを元にUserテーブル検索し、ログイン処理を試みる
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
