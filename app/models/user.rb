class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { participant: 0, admin: 1 }

  has_one_attached :profile_photo

  def confirmation_required?
    !admin?
  end
end
