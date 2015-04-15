class UserMailer < ActionMailer::Base
  default from: 'notifications@example.com'

  def confirm_sign_up
    mail(to: 'user@example.com', subject: 'Welcome to StacheMail') do |format|
      format.text
      format.html
    end
  end
end