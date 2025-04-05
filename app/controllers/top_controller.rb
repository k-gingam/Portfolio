class TopController < ApplicationController
  include PostsHelper # PostHelperをインクルード

  def index
    if logged_in?
      # 最新のポストを昇順でまとめておく
      @new_posts = Post.order(created_at: :desc).limit(10)
      # フォローしている人がいる場合、フォローが共有した動画を取得する
      if User.find_by(id: current_user.id).following_user
        follow_ids = []
        User.find_by(id: current_user.id).following_user.each do |follow|
          follow_ids.push(follow.id)
        end
        @follow_posts = Post.where(user_id: follow_ids)
      end
      # 閲覧履歴のポストに記載されているタグ、ゲーム名、ユーザー名からオススメポストを取得
      history_posts = History.where(user_id: current_user.id).order(updated_at: :desc).limit(5)
      # おすすめポストを格納するための配列
      @recommend_posts = []
      if history_posts.present?
        history_posts.each do |history|
          # 閲覧したポストに記載されたタグからポストを一件ずつ検索
          get_tag_name(history.post_id).each do |tag|
            # タグからポスト一覧を検索するが、自分が投稿したポストを検索結果から除外して1件だけ取得
            tag_random_post = Post.joins(:tags).where(tags: { name: tag }).where.not(user_id: current_user.id).order("RANDOM()").first
            # ポストがヒットした場合
            if !tag_random_post.nil?
              # 取得したポストが重複しない場合、ポスト情報を追加する
              @recommend_posts.push(tag_random_post) unless @recommend_posts.include?(tag_random_post)
            end
          end

          # 閲覧したポストに記載されたゲームからポストを一件検索
          game = get_game_name(history.post_id)
          # 自分が投稿したポスト以外で、ゲーム名が一致するポストを一件取得
          game_random_post = Post.joins(:games).where(games: { name: game }).where.not(user_id: current_user.id).order("RANDOM()").first
          # ポストがヒットした場合
          if !game_random_post.nil?
            # 取得したポストが重複しない場合、ポスト情報を追加する
            @recommend_posts.push(game_random_post) unless @recommend_posts.include?(game_random_post)
          end

          # 閲覧したポストに記載されたユーザーからポストを一件検索
          post = Post.find_by(id: history.post_id)
          # 閲覧したポストが自分のポストでない場合
          if post.user.name != current_user.name
            user_random_post = Post.where(user_id: current_user.id).order("RANDOM()").first
            # ポストがヒットした場合
            if !user_random_post.nil?
              # 取得したポストが重複しない場合、ポスト情報を追加する
              @recommend_posts.push(user_random_post) unless @recommend_posts.include?(user_random_post)
            end
          end
        end
      end

      # ログインしたユーザーがお気に入り登録しているゲームはないか
      if UserGame.exists?(user_id: current_user.id)
        # お気に入り登録しているゲームのポストから、自分が投稿したポスト以外でランダムに1件取得
        UserGame.where(user_id: current_user.id).each do |game_id|
          favorite_game_post = Post.joins(:post_games).select("posts.*, post_games.game_id").where(post_games: { game_id: game_id }).where.not(user_id: current_user.id).order("RANDOM()").first
          if !favorite_game_post.nil?
            @recommend_posts.push(favorite_game_post) unless @recommend_posts.include?(favorite_game_post)
          end
        end
      end

      # 閲覧履歴、お気に入りのゲームからポストを取得できたかどうか
      if @recommend_posts.present?
        # 取得したポストをランダムに並び変える
        @recommend_posts.shuffle!
      else
        # 全ポストからランダムに10件取得
        @recommend_posts = Post.order("RANDOM()").limit(10)
      end
    else
      # 管理者が投稿した未ログイン人向けのおすすめポストをランダムに3件取得
      @before_login_posts = Post.joins(:user).where(users: { name: "こうへい(管理人)", email: "k.kou29sky26@gmail.com" }).to_a.sample(3)
    end
  end
end
