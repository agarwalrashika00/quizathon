class NotificationsController < ApplicationController

  after_action :update_new_notifications, only: :index

  def index
    @new_notifications = current_user.notifications.where(read: false).all
    @old_notifications = current_user.notifications.where(read: true, created_at: 2.days.ago..Time.current)
  end

  private

  def update_new_notifications
    current_user.notifications.where(read: false).each do |notification|
      notification.update_column(:read, true)
    end
  end

end
