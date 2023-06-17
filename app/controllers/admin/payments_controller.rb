class Admin::PaymentsController < Admin::BaseController

  def index
    @q = Payment.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @payments = @q.result.includes(:user, :quiz).page(params[:page])
  end

end
