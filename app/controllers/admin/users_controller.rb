class Admin::UsersController < Admin::BaseController

  include Controllers::Blockable

  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @q = User.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @users = @q.result(distinct: true).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: 'User created successfully'
    else
      render :new, status: :unprocessable_entity
    end
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
    redirect_to :admin_users
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
