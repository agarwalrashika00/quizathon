module Models::Activable

  extend ActiveSupport::Concern

  def activate
    update_column(:active, true)
  end

  def inactivate
    update_column(:active, false)
  end

end
