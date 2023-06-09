class Payment < ApplicationRecord

  include Routing

  attr_accessor :stripe_session_url

  belongs_to :user
  belongs_to :quiz

  validates :amount, numericality: { greater_than: 0 }

  after_create_commit :create_stripe_session

  def self.ransackable_attributes(auth_object = nil)
    ['amount', 'created_at', 'currency_code', 'id', 'quiz_id', 'session_id', 'status', 'updated_at', 'user_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['user', 'quiz']
  end

  private

  def create_stripe_session
    stripe_session = Quizathon::StripePaymentProcessor.new(quiz_url(quiz, success: true), quiz_url(quiz), quiz, user).create_stripe_session
    self.session_id = stripe_session.id
    self.status = stripe_session.payment_status
    self.stripe_session_url = stripe_session.url
    save
  end

end
