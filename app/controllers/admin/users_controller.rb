class Admin::UsersController < ApplicationController
  before_action :ensure_is_admin
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
    if @user.update(u_params)
      redirect_to :admin_users, notice: "User #{@user.first_name} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:alert] = 'User was successfully destroyed.'
    else
      flash[:alert] = 'User cannot be destroyed.'
    end
    redirect_back fallback_location: root_path
  end

  private def ensure_is_admin
    unless current_user.present? && current_user.admin?
      redirect_to root_path, alert: 'You donot have privileges to access this section'
    end
  end

  private def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end
  
  private def set_user
    unless @user = User.find_by(id: params[:id])
      redirect_to admin_users_path, alert: 'User doesnot exist'
    end
  end
end
