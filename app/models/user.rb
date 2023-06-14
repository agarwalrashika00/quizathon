class User < ApplicationRecord

  include Models::Blockable
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  enum role: { participant: 0, admin: 1 }

  has_one_attached :profile_photo
  with_options dependent: :destroy do
    has_many :comments
    has_many :quiz_runners
    has_many :ratings
    has_many :payments
    has_many :notifications
  end
  has_many :quizzes, through: :quiz_runners

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def confirmation_required?
    !admin?
  end

  def after_confirmation
    WelcomeUserMailer.with(user: self).welcome_user_mail.deliver_now
  end

  def total_score
    quiz_runners.pluck(:score).compact.sum
  end

  def has_started?(quiz)
    quiz_runners.find_by_quiz_id(quiz.id)&.started?
  end

  def has_completed?(quiz)
    quiz_runners.find_by_quiz_id(quiz.id)&.completed?
  end

  def score_of(quiz)
    quiz_runners.find_by_quiz_id(quiz.id)&.score
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at email first_name id last_name notification_preferences role last_sign_in_at blocked confirmed_at]
  end

  def self.ransackable_associations(auth_obj = nil)
    []
  end

end
