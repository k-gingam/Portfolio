class SettingsController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = current_user
  end

  def email
    @user = current_user
  end

  def email_update
    @user = current_user

    if !User.where(email: user_params[:email]).exists?
      @user.update(after_change_email: user_params[:email])
      @user.change_email
      redirect_to root_path, success: "まだメールアドレスは変更されておりません、認証メールを確認してください。"
    else
      if current_user.email == user_params[:email]
        flash.now[:danger] = "変更したいメールアドレスを入力してください。"
        render :email, status: :unprocessable_entity
      else
        flash.now[:danger] = "入力されたメールアドレスは既に使用されています。"
        render :email, status: :unprocessable_entity
      end
    end
  end

  def password
    @user = current_user
  end

  def password_update
    @user = current_user

    if user_params[:password].present?
      if @user.update(user_params)
        redirect_to root_path, success: "パスワードを変更しました。"
      else
        flash.now[:danger] = "変更失敗しました。"
        render :password, status: :unprocessable_entity
      end
    end
  end

  def destroy; end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :after_change_email)
  end
end
