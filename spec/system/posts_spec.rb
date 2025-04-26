require 'rails_helper'

RSpec.describe "ポストに関する処理", type: :system do
  before do
    driven_by(:rack_test)
  end

  include LoginMacros
  include PostMacros
  let(:user) { User.create(name: "テストユーザー", email: "example@gmail.com", password: "password", password_confirmation: "password") }

  describe "ポストの投稿" do
    before { login_as(user) }

    it "ポストを投稿できる" do
      visit new_post_path
      fill_in '動画URL', with: "https://www.youtube.com/live/0dUzNxlovRs?si=uXpDlGOmlaM6H62G"
      fill_in 'コメント', with: 'コメントテスト'
      fill_in 'タグ', with: 'タグテスト1,タグテスト2'
      find('input.btn-primary.post-btn').click
      expect(page).to have_content "ポストを投稿しました"
    end

    it "動画URLが未入力の場合、投稿できない" do
      visit new_post_path
      fill_in '動画URL', with: ""
      fill_in 'コメント', with: 'コメントテスト'
      fill_in 'タグ', with: 'タグテスト1,タグテスト2'
      find('input.btn-primary.post-btn').click
      expect(page).to have_content "動画URLを入力してください"
    end

    it "動画URLが誤ってた場合、投稿できない" do
      visit new_post_path
      fill_in '動画URL', with: "https://test.com"
      fill_in 'コメント', with: 'コメントテスト'
      fill_in 'タグ', with: 'タグテスト1,タグテスト2'
      find('input.btn-primary.post-btn').click
      expect(page).to have_content "動画URLが正しくありません、YouTubeの共有ボタンからを取得してください"
    end

    it "コメントが未入力の場合、投稿できない" do
      visit new_post_path
      fill_in '動画URL', with: "https://www.youtube.com/live/0dUzNxlovRs?si=uXpDlGOmlaM6H62G"
      fill_in 'コメント', with: ""
      fill_in 'タグ', with: 'タグテスト1,タグテスト2'
      find('input.btn-primary.post-btn').click
      expect(page).to have_content "コメントを入力してください"
    end
  end

  describe "ポストの表示処理" do
    before { login_as(user) }

    it "ポストが正しく投稿されているか" do
      post_create
      visit profile_path(user.id)
      expect(page).to have_selector("a[href='https://www.youtube.com/watch?v=0dUzNxlovRs']")
      expect(page).to have_content "コメントテスト"
      expect(page).to have_content "タグテスト1"
      expect(page).to have_content "タグテスト2"
    end

    context "ポストを検索" do
      it "ポストのタグから検索" do
        post_create
        visit profile_path(user.id)
        click_link "#タグテスト1"
        expect(page).to have_content "\"タグテスト1\"検索結果"
        expect(page).to have_content "コメントテスト"
      end

      it "ヘッダーフォームからポスト検索" do
        post_create
        visit root_path
        fill_in "q[comment_or_tags_name_cont]", with: "コメントテスト"
        click_on "検索"
        expect(page).to have_content "\"コメントテスト\"検索結果"
        expect(page).to have_content "#タグテスト1"
      end
    end

    context "ポスト閲覧" do
      it "ポスト閲覧履歴に遷移" do
        visit posts_history_path
        expect(page).to have_content "閲覧履歴"
      end

      it "ポスト閲覧履歴がない場合" do
        visit posts_history_path
        expect(page).to have_content "閲覧履歴"
        expect(page).to have_content "閲覧したポストはありません。"
      end

      # it "ポスト閲覧した際、履歴に残る", js: true do
      # post_create
      # visit profile_path(user.id)
      # find('a.link-youtube-btn').click
      # visit posts_history_path
      # end
    end
  end
end
