class Admin::QuestionsController < Admin::BaseController

  include Controllers::Activable

  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @q = Question.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @questions = @q.result(distinct: true).page(params[:page])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to admin_questions_path, notice: 'Question created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      redirect_to :admin_questions, notice: "Question #{@question.title} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      redirect_to admin_questions_path, alert: 'Question destroyed successfully'
    else
      redirect_to admin_questions_path, alert: 'Question could not be destroyed'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :description, :score)
  end

  def set_question
    unless @question = Question.find_by(slug: params[:slug])
      redirect_to admin_questions_path, alert: 'Question doesnot exist'
    end
  end

end
