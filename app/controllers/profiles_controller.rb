class ProfilesController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    @posts = Post.where(user_id: @user.id)
    @user_follower = @user.follower_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path(@user.id), success: "変更しました"
    else
      flash.now[:danger] = "変更が失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :icon)
  end
end
