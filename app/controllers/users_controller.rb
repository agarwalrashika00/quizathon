class UsersController < ApplicationController

  before_action :set_user

  def my_quizzes
    @quizzes = current_user.quizzes.where('quiz_runners.status = ?', QuizRunner.statuses[:completed])
  end

  private

  def set_user
    @user = current_user
  end

end
