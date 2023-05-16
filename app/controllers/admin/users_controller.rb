class Admin::UsersController < ApplicationController
  before_action :verify_if_admin

  def index
    @users = User.order(params[:sort])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html{ redirect_to admin_users_path, notice: 'User created successfully'}
      else
        render 'new'
      end
  end
  end

  private def verify_if_admin
    unless current_user.present? && current_user.role == 'admin'
      redirect_to root_path, alert: 'You donot have privileges to access this section'
    end
  end

  private def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :role)
  end
end
