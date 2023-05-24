class Genre < ApplicationRecord

  include Models::Activable
  include Sluggable

  belongs_to :super_genre, class_name: 'Genre', optional: true
  has_many :sub_genres, class_name: 'Genre', foreign_key: 'super_genre_id'

  validates :title, uniqueness: { scope: :super_genre_id }, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :single_level_nesting

  def to_param
    slug
  end

  def self.ransackable_attributes(auth_object = nil)
    ['created_at', 'description', 'id', 'super_genre_id', 'title', 'updated_at', 'active']
  end

  def self.ransackable_associations(auth_object = nil)
    ['sub_genres', 'super_genre']
  end

  private

  def any_sub_genre_has_sub_genres?
    Genre.exists?(super_genre_id: sub_genre_ids)
  end

  def single_level_nesting
    if super_genre&.super_genre_id? || any_sub_genre_has_sub_genres? || (super_genre.present? && sub_genres.present?)
      errors.add :base, :nesting_level_too_deep, message: 'only one level of nesting is allowed'
    end
  end

end
