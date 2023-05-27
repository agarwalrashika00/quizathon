module Models::Blockable

  extend ActiveSupport::Concern

  def block
    update(blocked: true)
  end

  def unblock
    update(blocked: false)
  end

end
