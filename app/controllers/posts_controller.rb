class PostsController < ApplicationController
  # CSRFトークンを無視し、Ajaxでのリクエストを許可する
  skip_forgery_protection

  def new
    @post = Post.new
  end

  def create
    # 入力されたフォーム内容を元にUser型で宣言
    @post = current_user.posts.new(post_params)
    tag_names = params[:post][:tag].split(",")
    game_name = params[:post][:game_name]
    game_icon = params[:post][:game_icon]

    # 新規登録の処理(フォームが正しく入力され、DBに保存できるか)
    if @post.save
      # タグの保存処理、"model/post"で処理を行う
      @post.save_tags(tag_names)
      # ゲーム名が入力されている場合、ゲームの保存処理を行う
      if game_name.present?
        @post.save_game(game_name, game_icon)
      end

      # ポスト投稿完了後、トップページに戻る
      redirect_to root_path, success: t(".success_post")
    else
      flash.now[:danger] = t(".error_post")
      # Rails7で搭載されているTurbo対策用にstatusを設定、これがないとバリデーション失敗時のエラーが表示されない
      render :new, status: :unprocessable_entity
    end
  end

  def search
    # 検索に使用したワードを取得
    if params[:q].present?
      if params[:q][:comment_or_tags_name_cont].present?
        @search_ward = params[:q][:comment_or_tags_name_cont]
      elsif params[:q][:tags_name_eq].present?
        @search_ward = params[:q][:tags_name_eq]
      end
    end
  end

  def destroy
    # ポスト削除の処理
    Post.find_by(id: params[:id]).destroy
    redirect_to profile_path(current_user.id), info: t(".delete.delete_post")
  end

  def multi
    # 入力された検索キーワードの内、部分一致したワード5つを取得して検索候補に表示
    @search_tags = Tag.where("name like ?", "%#{params[:q]}%").limit(5)
    respond_to do |format|
      format.js
    end
  end

  def search_game
    # httpリクエスト、Ajaxでレスポンスを返す用のライブラリを読み込み
    require "net/http"
    require "uri"
    require "json"

    # IGDBのAPIを使用してゲーム名を検索
    uri = URI.parse("https://api.igdb.com/v4/games")
    word = ' " ' + params[:word] + ' " '
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "text/plain"
    request["Client-ID"] = ENV["IGDB_CLIENT_ID"]
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{ENV["IGDB_ACCESS_TOKEN"]}"

    # 検索したい内容をリクエストに追加する(ゲーム名を検索し、検索結果にIDとゲーム名を取得、追加コンテンツの名前は削除)
    request.body = "search #{word};
    fields name, cover.image_id;
    where category = (0,2,4,8,9,10,11) & version_parent = null;
    limit 10;"

    # 後で使う用のリクエスト文
    # game_localizations.region, game_localizations.cover.image_id, game_localizations.name

    # IGDBにリクエストを送信
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    # 取得したゲーム名とリージョンをJson形式に変換し、@gamesに代入
    @games = JSON.parse(response.body)

    # format.jsに@gamesのデータを入れてレスポンス設定
    respond_to do |format|
      format.js { render json: @games }
    end
  end

  def history
    # ログインしているユーザーの閲覧履歴を取得し、@history_postsに代入
    @history_posts = History.joins(:post).select("histories.*, posts.id, posts.user_id, posts.movie_url, posts.comment, posts.view_count, posts.created_at").where(user_id: current_user.id).order(updated_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:movie_url, :comment)
  end
end
