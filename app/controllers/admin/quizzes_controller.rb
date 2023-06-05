class Admin::QuizzesController < Admin::BaseController

  include Controllers::Activable

  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  def index
    @q = Quiz.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @quizzes = @q.result(distinct: true).page(params[:page])
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.created_by = current_user.id

    if @quiz.save
      redirect_to admin_quizzes_path, notice: 'Quiz created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @quiz.update(quiz_params)
      redirect_to :admin_quizzes, notice: "Quiz #{@quiz.title} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @quiz.destroy
      redirect_to admin_quizzes_path, alert: 'Quiz destroyed successfully'
    else
      redirect_to admin_quizzes_path, alert: 'Quiz could not be destroyed'
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:title, :description, :level, :time_limit_in_minutes, :quiz_banner, genre_ids: [], quiz_questions_attributes: [:id, :question_id, :active, :_destroy])
  end

  def set_quiz
    unless @quiz = Quiz.find_by(slug: params[:slug])
      redirect_to admin_quizzes_path, alert: 'Quiz doesnot exist'
    end
  end

end
