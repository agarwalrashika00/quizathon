class QuizAutocompleteJob < ApplicationJob

  @queue = :high_priority

  def perform(quiz_runner)
    unless quiz_runner.complete_quiz
      Logger.new("#{Rails.root}/log/my.log").info("cannot complete quiz with id #{quiz_runner.quiz.id} for user_id: #{quiz_runner.user.id}")
    end
  end

end
