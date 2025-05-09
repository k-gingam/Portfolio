Rails.application.routes.draw do
  get "oauths/oauth"
  get "oauths/callback"
  # root(トップページ)のルーティング設定
  root "top#index"

  # ユーザー登録処理のルーティング設定
  resources :users, only: %i[new create] do
    member do
      # メールアドレスの登録や変更時に認証処理を行うルーティング設定
      get :activate
    end
  end
  # ユーザーの退会処理のルーティング設定
  delete "users/destroy", to: "users#destroy"

  # ログイン処理のルーティング設定
  resource :login, only: %i[new create destroy]
  # パスワードリセットのルーティング設定
  resources :password_resets, only: %i[new create edit update]
  # プロフィール画面のルーティング設定
  resources :profiles, only: %i[show edit update destroy]

  # 設定画面のルーティング設定
  resources :settings, only: %i[edit destroy] do
    collection do
      # メールアドレス変更用のルーティング設定
      get :email
      patch :email_update, action: :email_update
      put :email_update, action: :email_update
      # パスワード変更用のルーティング設定
      get :password
      patch :password_update, action: :password_update
      put :password_update, action: :password_update
    end
  end

  # ポスト画面のルーティング設定
  resources :posts, only: %i[new create destroy]
  # ポスト検索画面のルーティング追加
  get "posts/search",  to: "posts#search"
  get "posts/multi",  to: "posts#multi"

  # ゲーム検索画面のルーティング追加
  post "posts/search_game",  to: "posts#search_game"

  # 閲覧履歴用のルーティング追加
  get "posts/history",  to: "posts#history"
  # 閲覧したポストを保存する用のルーティング追加
  post "histories/create", to: "histories#create"

  # ゲーム一覧及び詳細画面のルーティング追加
  resources :games, only: %i[show] do
    collection do
      get "list", to: "games#list"
    end
  end

  # ゲームのブックマークのルーティング追加
  post "bookmark/:id" => "bookmark#bookmark", as: "bookmark"
  post "unbookmark/:id" => "bookmark#unbookmark", as: "unbookmark"

  # フォロー機能作成用のルーティング設定
  post "follow/:id" => "follow#follow", as: "follow"
  post "unfollow/:id" => "follow#unfollow", as: "unfollow"
  get "follow/list" =>  "follow#list"

  # Googleログイン用のルーティング設定
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider


  # 利用規約、プライバシーポリシーのルーティング設定
  resource :term, only: %i[show]
  resource :privacy, only: %i[show]

  # ↓ここからは生成された時からあるもの
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # letteropenerのルーティング設定用(Portfolioはアプリケーション名)
  Portfolio::Application.routes.draw do
    mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.test?
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
