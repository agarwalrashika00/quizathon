class Admin::RatingsController < Admin::BaseController

  before_action :set_rating, only: :destroy

  def index
    @q = Rating.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @ratings = @q.result.includes(:quiz, :user).page(params[:page])
  end

  def destroy
    if @rating.destroy
      redirect_to admin_ratings_path, alert: 'Rating destroyed successfully'
    else
      redirect_to admin_ratings_path, alert: 'Rating cannot be destroyed'
    end
  end

  private

  def set_rating
    unless @rating = Rating.find_by_id(params[:id])
      redirect_to admin_ratings_path, notice: 'Rating does not exist'
    end
  end

end
