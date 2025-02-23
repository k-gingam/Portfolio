class TopController < ApplicationController
  def index
    if logged_in?
      # 最新のポストを昇順でまとめておく
      @new_posts = Post.order(created_at: :desc)

      # フォローしている人がいる場合、フォローが共有した動画を取得する
      if User.find_by(id: current_user.id).following_user
        follow_ids = []
        User.find_by(id: current_user.id).following_user.each do |follow|
            follow_ids.push(follow.id)
        end
        @follow_posts = Post.where(user_id: follow_ids)
      end
    else
      @Suggest_posts = Post.all
    end
  end
end
