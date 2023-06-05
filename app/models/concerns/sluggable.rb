module Sluggable

  extend ActiveSupport::Concern

  self.included do
    before_validation :generate_slug, unless: :slug?
  end

  private

  def generate_slug
    self.slug = self.class.to_s[0..1].upcase + SecureRandom.random_number(100000..999999).to_s
    if Genre.exists?(slug: slug)
      generate_slug
    end
  end

end
