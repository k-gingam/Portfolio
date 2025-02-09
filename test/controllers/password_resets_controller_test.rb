require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: "User", email: "test@example.com", password: "password") # テスト用ユーザーを作成
  end

  test "should get create" do
    get password_resets_create_url
    assert_response :success
  end

  test "should get edit" do
    get password_resets_edit_url
    assert_response :success
  end

  test "should get update" do
    get password_resets_update_url
    assert_response :success
  end
end
