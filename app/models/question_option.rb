class QuestionOption < ApplicationRecord

  include Models::Activable

  belongs_to :question
  has_one_attached :option_image

  validate :presence_of_either_data_or_image

  private

  def presence_of_either_data_or_image
    if option_image.present?
      self.data = ''
      self.type = 'ImageOption'
    else
      errors.add :base, 'Both data and image can\'t be blank' if data.blank?
      self.type = 'TextOption'
    end
  end

end
