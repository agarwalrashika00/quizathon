class Api::QuizzesController < ApplicationController

  def index
    render json: Quiz.where(active: true).map(&:serialize)
  end

end
