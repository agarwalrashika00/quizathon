module Models::Activable

  extend ActiveSupport::Concern

  def activate
    update(active: true)
  end

  def inactivate
    update(active: false)
  end

end
