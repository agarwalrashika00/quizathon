class Quiz < ApplicationRecord

  include Sluggable
  include Models::Activable
  include ActiveModel::Serializers::JSON

  attr_accessor :time_limit_in_minutes
  enum level: { beginner: 1, easy: 2, moderate: 3, difficult: 4, advance: 5 }

  has_and_belongs_to_many :genres
  has_many :quiz_questions, dependent: :destroy
  has_many :questions, through: :quiz_questions
  accepts_nested_attributes_for :quiz_questions, allow_destroy: true
  has_one_attached :quiz_banner
  has_many :comments, as: :commentable
  has_many :ratings
  has_many :quiz_runners
  has_many :users, through: :quiz_runners
  has_many :quiz_orders

  validates :title, presence: true
  validates :time_limit_in_seconds, numericality: { greater_than: 0 }
  validates_length_of :title_word_count, minimum: 5, message: 'should be at least 5', if: -> { title.present? }
  validates_length_of :description_word_count, minimum: 15, if: :description?
  validates :description, allow_blank: true, format: {
    without: Quizathon::URL_REGEXP
  }

  before_validation :set_time_limit_in_seconds

  scope :featured, -> {
    where(active: true).where('featured_at is not null').select { |quiz| Time.current > quiz.featured_at && Time.current < quiz.featured_at + 1.day }
  }

  def to_param
    slug
  end

  def average_rating
    ratings = self.ratings.pluck(:rating)
    if ratings.count.zero?
      'unrated'
    else
      ratings.sum.to_f / ratings.count
    end
  end

  def feature
    update_column(:featured_at, Time.current)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[active created_at created_by description featured_at genre_id id level slug time_limit_in_seconds title]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def serialize
    serializable_hash(only: [:slug, :title, :description, :time_limit_in_seconds, :level])
  end

  private

  def set_time_limit_in_seconds
    self.time_limit_in_seconds = time_limit_in_minutes.to_i * 60
  end

  def title_word_count
    title.split
  end

  def description_word_count
    description.split
  end

end
