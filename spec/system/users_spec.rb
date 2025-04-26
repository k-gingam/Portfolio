require 'rails_helper'

RSpec.describe "ユーザー設定に関する処理", type: :system do
  before do
    driven_by(:rack_test)
  end

  include LoginMacros
  let(:user) { User.create(name: "テストユーザー", email: "example@gmail.com", password: "password", password_confirmation: "password", activation_state: "active") }

  describe "ログイン前" do
    it "新規登録画面に遷移できる" do
      visit new_user_path
      expect(page).to have_content("新規ユーザー登録")
      expect(current_path).to eq new_user_path
    end

    describe "新規登録関連" do
      context "新規登録が成功" do
        it "ユーザーが新規登録できる" do
          visit new_user_path
          fill_in "名前", with: "テストユーザー"
          fill_in "メールアドレス", with: "example@gmail.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード確認", with: "password"
          click_button '登録'
          expect(page).to have_content '登録したメールアドレスに認証メールを送信しました。'
          expect(current_path).to eq new_login_path
        end
      end

      context "新規登録が失敗" do
        it "名前を未入力" do
          visit new_user_path
          click_button '登録'
          expect(page).to have_content '登録に失敗しました'
          expect(page).to have_content '名前を入力してください'
        end

        it "メールアドレスを未入力" do
          visit new_user_path
          click_button '登録'
          expect(page).to have_content '登録に失敗しました'
          expect(page).to have_content 'メールアドレスを入力してください'
        end

        it "パスワードが2文字以下の入力だった場合" do
          visit new_user_path
          click_button '登録'
          expect(page).to have_content '登録に失敗しました'
          expect(page).to have_content 'パスワードは3文字以上で入力してください'
        end

        it "パスワードとパスワード確認が不一致" do
          visit new_user_path
          fill_in "パスワード", with: "password"
          fill_in "パスワード確認", with: "passwordmiss"
          click_button '登録'
          expect(page).to have_content '登録に失敗しました'
          expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
        end
      end
    end

    context "ログイン処理関連" do
      it "ログインページに遷移できる" do
        visit new_login_path
        expect(page).to have_content 'ログインページ'
      end

      it "ログイン成功" do
        visit new_login_path
        User.find_by(email: user.email).update_columns(activation_state: "active", activation_token: nil, after_change_email: nil)
        fill_in 'メールアドレス', with: "example@gmail.com"
        fill_in 'パスワード', with: 'password'
        find('input.btn-primary.login-btn').click
        expect(page).to have_content 'ログインしました'
      end

      it "ログイン失敗(入力ミス)" do
        visit new_login_path
        User.find_by(email: user.email).update_columns(activation_state: "active", activation_token: nil, after_change_email: nil)
        fill_in 'メールアドレス', with: "test@gmail.com"
        fill_in 'パスワード', with: 'passwordmiss'
        find('input.btn-primary.login-btn').click
        expect(page).to have_content 'ログインに失敗しました'
      end

      it "ログイン失敗(アクティベート前)" do
        visit new_login_path
        fill_in 'メールアドレス', with: "example@gmail.com"
        fill_in 'パスワード', with: 'passwordmiss'
        find('input.btn-primary.login-btn').click
        expect(page).to have_content 'ログインに失敗'
      end

      it "ログアウトができる" do
        visit new_login_path
        User.find_by(email: user.email).update_columns(activation_state: "active", activation_token: nil, after_change_email: nil)
        fill_in 'メールアドレス', with: "example@gmail.com"
        fill_in 'パスワード', with: 'password'
        find('input.btn-primary.login-btn').click
        find('div.dropdown').click
        click_on "ログアウト"
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe "ログイン後" do
    before { login_as(user) }

    describe "フォロー処理関連" do
      let(:follow_user) { User.create(name: "フォロー用", email: "follow_test@gmail.com", password: "password", password_confirmation: "password", activation_state: "active") }

      it "ユーザーをフォロー" do
        User.find_by(email: follow_user.email).update_columns(activation_state: "active", activation_token: nil, after_change_email: nil)
        visit profile_path(follow_user.id)
        click_on "フォロー"
        expect(page).to have_content 'フォロー解除'
        expect(page).to have_content '1人のフォロワー'
      end

      it "ユーザーをフォロー解除" do
        User.find_by(email: follow_user.email).update_columns(activation_state: "active", activation_token: nil, after_change_email: nil)
        visit profile_path(follow_user.id)
        click_on "フォロー"
        click_on "フォロー解除"
        expect(page).to have_content 'フォロー'
      end

      context "フォロー一覧" do
        it "フォローしたユーザーがいない" do
          visit root_path
          click_link "フォロー一覧"
          expect(page).to have_content 'フォローしているユーザーはいません。'
        end

        it "フォローしたユーザーを表示" do
          User.find_by(email: follow_user.email).update_columns(activation_state: "active", activation_token: nil, after_change_email: nil)
          visit profile_path(follow_user.id)
          click_on "フォロー"
          click_link "フォロー一覧"
          expect(page).to have_content 'フォロー用'
        end
      end
    end

    describe "プロフィール関連" do
      it "マイページに遷移できる" do
        visit root_path
        find('div.dropdown').click
        click_on "マイページ"
        expect(page).to have_content("テストユーザー")
      end

      context "プロフィールの設定変更" do
        it "プロフィール設定変更画面に遷移する" do
          visit profile_path(user.id)
          click_on "編集"
          expect(page).to have_content("プロフィール設定")
        end

        it "名前と自己紹介文を変更できる" do
          visit profile_path(user.id)
          click_on "編集"
          fill_in '名前', with: "テストユーザー_変更"
          fill_in '自己紹介', with: '自己紹介テキスト'
          click_on "変更"
          expect(page).to have_content("変更しました")
          expect(page).to have_content("テストユーザー_変更")
          expect(page).to have_content("自己紹介テキスト")
        end

        it "アイコンを変更できる" do
          visit profile_path(user.id)
          click_on "編集"
          attach_file 'user[icon]', File.join(Rails.root, 'spec/fixtures/images/test.png')
          click_on "変更"
          expect(page).to have_content("変更しました")
          expect(page).to have_selector("img[src$='test.png']")
        end
      end

      context "プロフィールの設定変更失敗" do
        it "名前が無入力の場合、変更できない" do
          visit profile_path(user.id)
          click_on "編集"
          fill_in '名前', with: ""
          click_on "変更"
          expect(page).to have_content("名前を入力してください")
        end
      end
    end

    describe "ユーザー設定関連" do
      context "メールアドレス変更が成功" do
        it "メールアドレス変更ができる" do
          visit root_path
          find('div.dropdown').click
          click_on "設定"
          click_on "メールアドレス変更"
          fill_in "メールアドレス", with: "example_change@gmail.com"
          click_button '変更'
          expect(page).to have_content "まだメールアドレスは変更されておりません、認証メールを確認してください。"
        end
      end

      context "メールアドレス変更が失敗" do
        it "変更前のメールアドレスを入力" do
          visit root_path
          find('div.dropdown').click
          click_on "設定"
          click_on "メールアドレス変更"
          fill_in "メールアドレス", with: "example@gmail.com"
          click_button '変更'
          expect(page).to have_content "変更したいメールアドレスを入力してください。"
        end

        it "既に登録済のメールアドレスを入力" do
          User.create(name: "テストユーザー", email: "example2@gmail.com", password: "password", password_confirmation: "password", activation_state: "active")
          visit root_path
          find('div.dropdown').click
          click_on "設定"
          click_on "メールアドレス変更"
          fill_in "メールアドレス", with: "example2@gmail.com"
          click_button '変更'
          expect(page).to have_content "入力されたメールアドレスは既に使用されています。"
        end
      end

      context "パスワード変更" do
        it "パスワード変更が成功" do
          visit root_path
          find('div.dropdown').click
          click_on "設定"
          click_on "パスワード変更"
          fill_in "パスワード", with: "newpassword"
          fill_in "パスワード確認", with: "newpassword"
          click_button '変更'
          expect(page).to have_content "パスワードを変更しました。"
        end

        it "パスワード変更が失敗" do
          visit root_path
          find('div.dropdown').click
          click_on "設定"
          click_on "パスワード変更"
          fill_in "パスワード", with: "newpassword"
          fill_in "パスワード確認", with: "newpasswordmiss"
          click_button '変更'
          expect(page).to have_content "パスワード確認とパスワードの入力が一致しません"
        end
      end

      it "ユーザー退会ができる" do
        visit root_path
        find('div.dropdown').click
        click_on "設定"
        click_on "退会する"
        expect(page).to have_content "退会しました。"
      end
    end
  end
end
