class QuizzesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_quiz, only: [:show]

  def index
    @q = Quiz.where(active: true).ransack(params[:q])
    @quizzes = @q.result(distinct: true)
  end

  private

  def set_quiz
    unless @quiz = Quiz.find_by(slug: params[:slug])
      redirect_to users_quizzes_path, alert: 'Quiz doesnot exist'
    end
  end

end
