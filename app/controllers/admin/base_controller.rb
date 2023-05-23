class Admin::BaseController < ApplicationController
  before_action :ensure_is_admin

  private def ensure_is_admin
    unless current_user.present? && current_user.admin?
      redirect_to root_path, alert: 'You donot have privileges to access this section'
    end
  end
end