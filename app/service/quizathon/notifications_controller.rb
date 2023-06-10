module Quizathon

  class NotificationsController

    def initialize(parent_comment)
      @parent_comment = parent_comment
    end

    def notify_parent
      if @parent_comment
        Notification.create(user_id: @parent_comment.user.id, data: 'Someone commented on your post')
        ActionCable.server.broadcast('notification_channel', {parent_comment_user_id: @parent_comment.user.id})
      end
    end

  end

end
