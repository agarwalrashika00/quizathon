class Api::QuizzesController < ApplicationController

  skip_before_action :authenticate_user!

  def index
    render json: Quiz.active, each_serializer: QuizSerializer
  end

end
