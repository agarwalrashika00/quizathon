class Question < ApplicationRecord

  include Models::Activable
  include Sluggable

  has_many :question_options, dependent: :destroy
  accepts_nested_attributes_for :question_options, allow_destroy: true
  has_many :quiz_questions, dependent: :destroy
  has_many :quizzes, through: :quiz_questions
  has_many :started_quiz_runners, through: :quizzes

  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :score, numericality: { only_integer: true, greater_than: 0 }
  validate :options_count
  validate :only_one_correct_option

  before_validation ActivableCallbacks, on: :update

  scope :active, -> {
    where(active: true)
  }

  def to_param
    slug
  end

  def correct_option
    question_options.find_by(correct: true)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[active created_at description id score title updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def only_one_correct_option
    unless question_options.where(correct: true).count == 1
      errors.add :base, 'Choose exactly one correct option.'
    end
  end

  def options_count
    count = question_options.size
    question_options.each do |option|
      count -= 1 if option.marked_for_destruction?
    end
    errors.add :base, 'enter exactly 4 options' unless count == 4
  end

end
