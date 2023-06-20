class NotificationsController < ApplicationController

  after_action :update_new_notifications, only: :index

  def index
    @new_notifications = current_user.notifications.unread.all
    @old_notifications = current_user.notifications.read.where(created_at: 2.days.ago..Time.current)
  end

  private

  def update_new_notifications
    current_user.notifications.unread.each do |notification|
      notification.update_column(:read, true)
    end
  end

end
