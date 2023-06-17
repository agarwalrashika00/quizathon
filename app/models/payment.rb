class Payment < ApplicationRecord

  include Routing

  attr_accessor :stripe_session_url

  belongs_to :user
  belongs_to :quiz

  after_create_commit :create_stripe_session

  def self.ransackable_attributes(auth_object = nil)
    ['amount', 'created_at', 'currency_code', 'id', 'quiz_id', 'session_id', 'status', 'updated_at', 'user_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['user', 'quiz']
  end

  private

  def create_stripe_session
    session = Quizathon::StripePaymentProcessor.new(quiz_url(quiz, success: true), quiz_url(quiz), quiz, user).create_stripe_session
    self.session_id = session.id
    self.status = session[:payment_status]
    self.stripe_session_url = session.url
    save
  end

end
