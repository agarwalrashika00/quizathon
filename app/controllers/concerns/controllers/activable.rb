module Controllers::Activable

  extend ActiveSupport::Concern

  included do
    before_action :set_model_instance, only: [:activate, :inactivate]
  end

  def activate
    if @model_instance.activate && @model_instance.active?
      flash[:alert] = "#{controller_name.classify} was successfully activated."
    else
      flash[:alert] = "#{controller_name.classify} cannot be activated."
    end
    redirect_to send("admin_#{controller_name}_path"), allow_other_host: true
  end

  def inactivate
    if @model_instance.inactivate
      flash[:alert] = "#{controller_name.classify} was successfully inactivated."
    else
      flash[:alert] =  @model_instance.errors[:active].first
    end    
    redirect_to send("admin_#{controller_name}_path"), allow_other_host: true
  end

  private

  def set_model_instance
    unless @model_instance = controller_name.classify.constantize.find_by(slug: params[:slug])
      redirect_to send("admin_#{controller_name}_path"), alert: "#{controller_name.classify} doesnot exist"
    end
  end

end
