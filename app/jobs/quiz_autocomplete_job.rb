class QuizAutocompleteJob < ApplicationJob

  @queue = :high_priority

  def perform(quiz_runner)
    quiz_runner.complete_quiz
  end

end
