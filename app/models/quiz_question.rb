class QuizQuestion < ApplicationRecord

  belongs_to :quiz
  belongs_to :question

  validates :question_id, uniqueness: { scope: :quiz_id, message: 'Choose new' }
  validate :donot_modify_quiz, on: :update
  validate :donot_modify_question, on: :update

  before_destroy :donot_destroy

  private

  def donot_modify_quiz
    errors.add :quiz_id, 'cannot be modified' if quiz_id_was != quiz_id
  end

  def donot_modify_question
    errors.add :question_id, 'cannot be modified' if question_id_was != question_id
  end

  def donot_destroy
    errors.add(:base, 'cannot be destroyed')
    throw :abort
  end

end
