class Question < ApplicationRecord

  include Models::Activable
  include Sluggable

  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :score, numericality: { only_integer: true, greater_than: 0 }

  def to_param
    slug
  end

  def self.ransackable_attributes(auth_object = nil)
    ['active', 'created_at', 'description', 'id', 'score', 'title', 'updated_at']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

end
