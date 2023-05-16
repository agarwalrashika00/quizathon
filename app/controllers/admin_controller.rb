class AdminController < ApplicationController
  before_action :verify_if_admin

  def index
  end

  private def verify_if_admin
    unless current_user.present? && current_user.role == 'admin'
      redirect_to root_path, alert: "You don't have privileges to access this section"
    end
  end
end