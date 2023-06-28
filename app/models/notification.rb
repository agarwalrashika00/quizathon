class Notification < ApplicationRecord

  belongs_to :user

  validates :data, presence: true

  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }
  scope :recent, -> { where(created_at: 2.days.ago..Time.current) }

end
