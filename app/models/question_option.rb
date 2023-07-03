class QuestionOption < ApplicationRecord

  include Models::Activable

  belongs_to :question
  has_one_attached :option_image

  validate :presence_of_either_data_or_image

  before_validation :set_type

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

end
