class OauthsController < ApplicationController
  # skip_before_action :require_login

  def oauth
    # 指定されたプロバイダの認証ページにユーザーをリダイレクトさせる
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    # 既存のユーザーをプロバイダ情報を元に検索し、存在すればログイン
    if (@user = login_from(provider))
      redirect_to root_path, success: "#{provider.titleize}アカウントでログインしました"
    else
      begin
        # ユーザーが存在しない場合はプロバイダ情報を元に新規ユーザーを作成し、ログイン
        signup_and_login(provider)
        redirect_to root_path, success: "#{provider.titleize}アカウントで登録しました"
      rescue
        redirect_to root_path, danger: "#{provider.titleize}アカウントでのログインに失敗しました。既に登録されているメールアドレスです。"
      end
    end
  end

  private

  def auth_params
    params.permit(:provider, :code, :scope, :authuser, :prompt)
  end

  def signup_and_login(provider)
    # 新規ユーザーの作成
    @user = create_from(provider)
    # よく分かってないが、恐らく現在ログインしているセッション情報を削除？
    reset_session
    # 新規ユーザーでログインする(これらはsorceryのメソッド)
    auto_login(@user)
  end
end
