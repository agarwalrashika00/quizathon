class NotificationsController < ApplicationController

  after_action :update_new_notifications, only: :index

  def index
    @new_notifications = current_user.notifications.unread
    @old_notifications = current_user.notifications.read.recent
  end

  private

  def update_new_notifications
    current_user.notifications.unread.each do |notification|
      notification.update_column(:read, true)
    end
  end

end
