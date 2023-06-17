module Quizathon

  class NotificationsManager

    def initialize(commenter, parent_comment, quiz)
      @commenter = commenter
      @parent_comment = parent_comment
      @quiz = quiz
    end

    def notify_in_app?
      @parent_comment&.user.notification_preferences["in_app"]
    end

    def notify_by_email?
      @parent_comment&.user.notification_preferences["email"]
    end

    def notify_parent
      if notify_in_app?
        Notification.create(user_id: @parent_comment.user.id, data: "#{@commenter.full_name} replied to your comment on quiz #{@quiz.title}")
        ActionCable.server.broadcast('notification_channel', {parent_comment_user_id: @parent_comment.user.id})
      end

      if notify_by_email?
        NotificationMailer.with(user: @parent_comment.user, commenter: @commenter, quiz: @quiz).comment_reply_email.deliver_later
      end
    end

  end

end
