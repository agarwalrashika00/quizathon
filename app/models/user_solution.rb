class UserSolution < ApplicationRecord

  belongs_to :user
  belongs_to :quiz_question
  belongs_to :question_option, foreign_key: :marked_option_id

end
