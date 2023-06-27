class QuizzesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_quiz, except: [:index]
  before_action :set_quiz_runner, only: [:resume, :submit, :complete]
  before_action :ensure_quiz_not_completed, only: :submit

  def index
    @q = Quiz.where(active: true).ransack(params[:q])
    @quizzes = @q.result(distinct: true)
  end
  
  def show
    payments_manager = Quizathon::PaymentsProcessor.new(current_user, @quiz)
    payments_manager.update_payment
    flash[:alert] = payments_manager.errors.join(',') if payments_manager.errors.present?
    @can_play = payments_manager.user_can_play_quiz?
  end

  def start
    questions_sorting_order = @quiz.active_questions.pluck(:slug).shuffle
    quiz_runner = current_user.quiz_runners.build(quiz: @quiz, status: 'started', questions_sorting_order: questions_sorting_order)
    if quiz_runner.save
      redirect_to question_path(question_slug: questions_sorting_order.first)
    else
      redirect_to quiz_path(@quiz), notice: quiz_runner.errors.to_a
    end
  end

  def resume
    redirect_to question_path(question_slug: @quiz_runner.questions_sorting_order.first )
  end

  def complete
    if @quiz_runner.complete_quiz
      redirect_to quiz_path(@quiz), notice: 'You successfully completed the quiz. Try some other quiz.'
    else
      redirect_to quiz_path(@quiz), notice: @quiz_runner.errors.to_a
    end
  end

  def comment
    comment = @quiz.comments.build(comment_params.merge(user_id: current_user.id))
    if comment.save
      redirect_to quiz_path(@quiz)
      ActionCable.server.broadcast('comments', { html: render_to_string(@quiz.comments.published, layout: false), quiz_id: @quiz.id })
    else
      render 'quizzes/show', alert: 'Your comment could not be added.'
    end
  end

  def rate
    rating = Rating.find_or_initialize_by(user: current_user, quiz: @quiz)
    rating.value = params[:value]

    if rating.save
      redirect_to quiz_path(@quiz), notice: 'Rating added successfully.'
      @q = Quiz.where(active: true).ransack(params[:q])
      @quizzes = @q.result(distinct: true)
      ActionCable.server.broadcast('ratings', { html: render_to_string(partial: 'quizzes/quizzes', object: @quizzes, locals: { q: @q }, layout: false) })
    else
      redirect_to quiz_path(@quiz), alert: 'Rating could not be added.'
    end
  end

  private

  def set_quiz
    unless @quiz = Quiz.find_by(slug: params[:slug])
      redirect_to quizzes_path, alert: t(:quiz_not_found)
    end
  end

  def set_quiz_runner
    unless @quiz_runner = QuizRunner.find_by(quiz: @quiz, user: current_user)
      redirect_to quiz_path(@quiz), alert: 'Quiz runner doesnot exist'
    end
  end

  def comment_params
    params.require(:comment).permit(:data, :parent_comment_id, :user_id)
  end

  def ensure_quiz_not_completed
    if @quiz_runner.completed?
      redirect_to quiz_path(@quiz), alert: 'You have attempted the quiz.'
    end
  end

end
