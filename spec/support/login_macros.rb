module LoginMacros
  def login_as(user)
    User.find_by(email: user.email).update_columns(activation_state: "active", activation_token: nil, after_change_email: nil)
    visit new_login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    find('input.btn-primary.login-btn').click
  end
end
