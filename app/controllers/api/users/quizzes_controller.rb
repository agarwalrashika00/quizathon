class Api::Users::QuizzesController < ApplicationController

  def index
    render json: current_user.quizzes.map(&:serialize)
  end

end
