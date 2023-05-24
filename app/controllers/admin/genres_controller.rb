class Admin::GenresController < Admin::BaseController

  include Controllers::Activable
 
  before_action :set_genre, only: [:edit, :update, :destroy]

  def index
    @q = Genre.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @genres = @q.result(distinct: true).page(params[:page])
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)

    if @genre.save
      redirect_to admin_genres_path, notice: 'Genre created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @genre.update(genre_params)
      redirect_to :admin_genres, notice: "Genre #{@genre.title} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @genre.destroy
      redirect_to admin_genres_path, alert: 'Genre destroyed successfully'
    else
      redirect_to admin_genres_path, alert: 'Genre could not be destroyed'
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:title, :description, :super_genre_id)
  end

  def set_genre
    unless @genre = Genre.find_by(slug: params[:slug])
      redirect_to admin_genres_path, alert: 'Genre doesnot exist'
    end
  end

end
