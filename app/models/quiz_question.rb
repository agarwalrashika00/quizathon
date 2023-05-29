class QuizQuestion < ApplicationRecord

  belongs_to :quiz
  belongs_to :question

  validates :question_id, uniqueness: { scope: :quiz_id, message: 'Choose new' }

end
