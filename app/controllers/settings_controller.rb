class SettingsController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to root_path, success: "変更しました"
    else
      flash.now[:danger] = "変更失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
