class NotificationMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def comment_reply_email
    @user = params[:user]
    @commenter = params[:commenter]
    @quiz = params[:quiz]
    mail(to: @user.email, subject: 'Someone replied to your comment')
  end

end
