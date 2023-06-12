# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  def comment_reply_email
    comment = Comment.find_by('parent_comment_id is not null')
    NotificationMailer.with(user: comment.parent_comment.user, commenter: comment.user, quiz: comment.commentable).comment_reply_email
  end

end
