class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = User.find user.id
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email,
         subject: "パスワード変更の手続き")
  end

  def activation_needed_email(user)
    @user = user
    @url  = activate_user_url(@user.activation_token)
    if !user.after_change_email.nil?
      mail(to: user.after_change_email, subject: "メール認証のお知らせ")
    else
      mail(to: user.email, subject: "メール認証のお知らせ")
    end
  end

  def activation_success_email(user); end
end
