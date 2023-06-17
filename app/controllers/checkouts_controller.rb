class CheckoutsController < ApplicationController

  before_action :set_quiz, only: :create

  def create
    payment = Payment.new(quiz_id: @quiz.id, user_id: current_user.id, amount: @quiz.amount, currency_code: @quiz.currency_code)

    if payment.save
      redirect_to payment.stripe_session_url, allow_other_host: true
    else
      redirect_to quiz_path(@quiz), notice: payment.errors.to_a
    end
  end

  private

  def set_quiz
    unless @quiz = Quiz.find_by_slug(params[:slug])
      redirect_to :quizzes_path, alert: t(:quiz_not_found)
    end
  end

end
