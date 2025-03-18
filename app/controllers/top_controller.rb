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
      @before_login_posts = Post.joins(:user).where(users: { name: "こうへい(管理人)", email: "k.kou29sky26@gmail.com" }).to_a.sample(3)
    end
  end
end
