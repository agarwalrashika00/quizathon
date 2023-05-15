class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { participant: 0, admin: 1 }

  validates :first_name, presence: true

  def confirmation_required?
    !admin?
  end
end
