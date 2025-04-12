class FollowController < ApplicationController
  # フォローボタンが押された時の処理
  def follow
    current_user.follow(params[:id])
    redirect_to profile_path(params[:id])
  end
  # フォロー解除ボタンが押された時の処理
  def unfollow
    current_user.unfollow(params[:id])
    redirect_to profile_path(params[:id])
  end

  def list
    if User.find_by(id: current_user.id).following_user
      @follows= []
      User.find_by(id: current_user.id).following_user.each do |follow|
        @follows.push(follow)
      end
    end
  end
end
