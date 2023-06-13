class CheckoutsController < ApplicationController

  before_action :set_quiz, only: :create

  def create
    session = Quizathon::CheckoutsController.new(quiz_url(@quiz, success: true), quiz_url(@quiz), @quiz, "inr", 500, current_user).create_stripe_session
    quiz_order = QuizOrder.new(session_id: session.id, quiz_id: @quiz.id, user_id: current_user.id, status: session[:payment_status], amount: 5, currency_code: 'inr')

    if quiz_order.save
      redirect_to session.url, allow_other_host: true
    else
      redirect_to quiz_path(quiz), notice: quiz_order.errors.to_a
    end
  end

  private

  def set_quiz
    unless @quiz = Quiz.find_by_slug(params[:slug])
      redirect_to :quizzes_path, alert: 'Quiz not found'
    end
  end

end
