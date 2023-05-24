module BlockUnblock

  extend ActiveSupport::Concern

  included do
    before_action :set_model_instance, only: [:block, :unblock]
  end

  def block
    if @model_instance.block
      flash[:alert] = "#{controller_name.classify} was successfully blocked."
    else
      flash[:alert] = "#{controller_name.classify} cannot be blocked."
    end
    redirect_to admin_users_path
  end

  def unblock
    if @model_instance.unblock
      flash[:alert] = "#{controller_name.classify} was successfully unblocked."
    else
      flash[:alert] = "#{controller_name.classify} cannot be unblocked."
    end
    redirect_to admin_users_path
  end

  private def set_model_instance
    unless @model_instance = controller_name.classify.constantize.find_by(id: params[:id])
      redirect_to admin_users_path, alert: "#{controller_name.classify} doesnot exist"
    end
  end

end
