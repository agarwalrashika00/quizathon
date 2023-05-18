class Admin::UsersController < ApplicationController
  before_action :verify_if_admin
  before_action :set_user, only: [:edit, :update, :destroy]

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
        format.html { redirect_to admin_users_path, notice: 'User created successfully' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    render :new
  end

  def edit
  end

  def update
    if(user_params[:password].present?)
      u_params = user_params
    else
      u_params = user_params.except(:password, :password_confirmation)
    end
    respond_to do |format|
      if @user.update(u_params)
        format.html { redirect_to :admin_users, notice: "User #{@user.first_name} was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @user.destroy
      flash[:alert] = 'User was successfully destroyed.'
    else
      flash[:alert] = 'User cannot be destroyed.'
    end
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private def verify_if_admin
    unless current_user.present? && current_user.role == 'admin'
      redirect_to root_path, alert: 'You donot have privileges to access this section'
    end
  end

  private def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end
  
  private def set_user
    @user = User.find(params[:id])
  end
end
