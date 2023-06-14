class User < ApplicationRecord

  include Models::Blockable
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  enum role: { participant: 0, admin: 1 }

  has_one_attached :profile_photo
  has_many :comments
  has_many :quiz_runners
  has_many :quizzes, through: :quiz_runners
  has_many :ratings
  has_many :quiz_orders

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def confirmation_required?
    !admin?
  end

  def after_confirmation
    WelcomeUserMailer.with(user: self).welcome_user_mail.deliver_now
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at email first_name id last_name notification_preferences role last_sign_in_at blocked confirmed_at]
  end

  def self.ransackable_associations(auth_obj = nil)
    []
  end

end
