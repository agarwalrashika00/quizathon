class Notification < ApplicationRecord

  belongs_to :user

  validates :data, presence: true

  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }

end
