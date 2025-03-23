module PostsHelper
  # YouTubeAPIを使用し、動画情報を取得するメソッド
  def youtube_get_item(video_url)
    require "google/apis/youtube_v3"

    # 入力されたURLからvideo_idを取得
    @video_id = get_video_id(video_url)

    # 取得した動画情報は1日だけキャッシュに保存(YouTubeリクエスト制限対策)
    Rails.cache.fetch("youtube_thumbnail_#{@video_id}", expires_in: 1.day) do
      youtube = Google::Apis::YoutubeV3::YouTubeService.new
      youtube.key = ENV["YOUTUBE_ACCESS_KEY_ID"]

      # ビデオの詳細情報（snippet）を取得
      video_response = youtube.list_videos("snippet", id: @video_id)
      video = video_response.items.first
      video

      # video_info = [ { thumbnail: video.snippet.thumbnails.standard.url, title: video.snippet.title } ]
    end
  end

  # YouTubeの動画リンクからビデオIDを抽出するメソッド
  def get_video_id(url)
    return nil if url.nil?

    # URLを解析してビデオIDを取得する
    uri = URI.parse(url) # 入力されたURLをURI形式に変換
    URI(uri.path.split("/").last)  # URLに含まれている動画idを返す
  end

  # ポストに貼られたタグ名を取得するメソッド
  def get_tag_name(id)
    @tag_names = []
    if PostTag.exists?(post_id: id)
      PostTag.where(post_id: id).each do |tag|
        @tag_names << Tag.find_by(id: tag.tag_id).name
      end
    end
    @tag_names
  end

  # ポストに貼られたゲーム名を取得するメソッド
  def get_game_name(id)
    if PostGame.exists?(post_id: id)
      game = Game.find_by(id: PostGame.find_by(post_id: id).game_id).name
    end
    game
  end

  # ポストが表示された回数をカウントするメソッド
  def postview_count(post)
    # HistoryテーブルとPostテーブルを結合した際にpost_idメソッドが出来てしまう為、メソッドの存在チェックにより参照ポストIDを変更
    if post.respond_to?(:post_id)
      Post.find_by(id: post.post_id).update(view_count: post.view_count + 1)
    else
      Post.find_by(id: post.id).update(view_count: post.view_count + 1)
    end
    nil
  end

  # どれくらい前にポストされたものか計算するメソッド
  def posttime_output(post_time)
    # 引数でもらった時刻と現在時刻を元に計算
    start_time = DateTime.parse(Time.current.to_s)
    end_time = DateTime.parse(post_time.to_s)

    # この時の計算結果は、2つの日時差分の合計秒数/一日の秒数(86400秒)となる。
    # これによりポストから何日経過したのかが把握できる
    result_time = start_time - end_time

    # 計算結果から日、時間、分、秒に細かく分ける
    days = result_time.to_i
    sum_seconds = (result_time - days).to_f * 24 * 60 * 60
    hours = (sum_seconds / 3600).to_i
    minutes = (sum_seconds % 3600 / 60).to_i
    seconds = (sum_seconds % 60).to_i

    # 条件に合わせてどれくらい前に投稿されたポストなのか表示する
    if days > 0
      if days <= 10
        days.to_s + "日前"
      else
        post_time.strftime("%Y/%m/%d")
      end
    elsif hours > 0
      hours.to_s + "時間前"
    elsif minutes > 0
      minutes.to_s + "分前"
    else
      "1分以内"
    end
  end
end
