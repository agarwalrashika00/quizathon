# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  # before_action :configure_sign_in_params, only: [:create]
  before_action :ensure_unblocked, only: :create

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  private

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def ensure_unblocked
    if User.find_by(email: params[:user][:email])&.blocked?
      redirect_to new_user_session_path, notice: 'You are currently blocked'
    end
  end

end
