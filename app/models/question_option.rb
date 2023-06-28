class QuestionOption < ApplicationRecord

  include Models::Activable

  belongs_to :question
  has_one_attached :option_image

  validate :presence_of_either_data_or_image

  before_validation :set_type
  after_commit :update_question, on: [:update, :destroy]

  scope :correct, -> { where(correct: true) }

  private

  def presence_of_either_data_or_image
    if option_image.blank? && data.blank?
      errors.add :base, 'Both data and image can\'t be blank'
    end
  end

  def set_type
    if option_image.present?
      self.data = ''
      self.type = 'ImageOption'
    else
      self.type = 'TextOption'
    end
  end

  def update_question
    question.inactivate unless question.publishable?

    if question_id_before_last_save && question_id_before_last_save != question_id
      previous_question = Question.find_by_id(question_id_before_last_save)
      previous_question.inactivate unless previous_question.publishable?
    end
  end

end
