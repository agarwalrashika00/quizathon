class Rating < ApplicationRecord

  belongs_to :quiz
  belongs_to :user

  validates :quiz_id, uniqueness: { scope: :user_id }

  def self.ransackable_attributes(auth_object = nil)
    ['created_at', 'id', 'quiz_id', 'value', 'updated_at', 'user_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['quiz', 'user']
  end

end
