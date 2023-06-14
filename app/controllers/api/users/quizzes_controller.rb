class Api::Users::QuizzesController < ApplicationController

  def index
    render json: current_user.quizzes, each_serializer: QuizSerializer
  end

end
