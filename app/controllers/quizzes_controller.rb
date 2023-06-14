class QuizzesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_quiz, except: [:my_quizzes, :index]
  before_action :set_quiz_runner, only: [:submit, :complete]

  def index
    @q = Quiz.where(active: true).ransack(params[:q])
    @quizzes = @q.result(distinct: true)
  end
  
  def show
    @rating = Rating.find_or_initialize_by(user: current_user, quiz: @quiz)
  end

  def start
    questions_sorting_order = @quiz.questions.pluck(:slug).shuffle
    quiz_runner = QuizRunner.new(user: current_user, quiz: @quiz, status: 'started', questions_sorting_order: questions_sorting_order.to_s.remove('"', ' '))
    if quiz_runner.save
      session[:quiz_runner_id] = quiz_runner.id
      session[:start_time] = Time.now
      redirect_to question_path(question_slug: questions_sorting_order.first)
    else
      redirect_to quiz_path(@quiz), notice: quiz_runner.errors.to_a
    end
  end

  def submit
    if @quiz_runner.status == 'completed'
      redirect_to quiz_path(@quiz), alert: 'You have already attempted the quiz once.'
    end
  end

  def complete
    if @quiz_runner.complete_quiz
      session[:quiz_runner_id] = nil
      redirect_to quiz_path(@quiz), notice: 'You successfully completed the quiz. Try some other quiz.'
    else
      redirect_to quiz_path(@quiz), notice: @quiz_runner.errors.to_a
    end
  end

  def my_quizzes
    @quiz_runners = QuizRunner.where(user: current_user)
  end

  def comment
    comment = @quiz.comments.build(comment_params)
    if comment.save
      @comments = Comment.where(commentable: @quiz)
      ActionCable.server.broadcast('comments', { html: render_to_string('quizzes/show', layout: false) })
    else
      render 'quizzes/show', alert: 'Your comment could not be added.'
    end
  end

  def rate
    rating = Rating.find_or_initialize_by(user: current_user, quiz: @quiz)
    rating.rating = params[:rating]

    if rating.save
      redirect_to quiz_path(@quiz), notice: 'Rating added successfully.'
      @q = Quiz.where(active: true).ransack(params[:q])
      @quizzes = @q.result(distinct: true)
      ActionCable.server.broadcast('ratings', { html: render_to_string('quizzes/index', layout: false) })
    else
      redirect_to quiz_path(@quiz), alert: 'Rating could not be added.'
    end

  end


  private

  def set_quiz
    unless @quiz = Quiz.find_by(slug: params[:slug])
      redirect_to users_quizzes_path, alert: 'Quiz doesnot exist'
    end
  end

  def set_quiz_runner
    unless @quiz_runner = QuizRunner.find_by_id(session[:quiz_runner_id])
      redirect_to quiz_path(@quiz), alert: 'Quiz runner doesnot exist'
    end
  end

  def comment_params
    params.require(:comment).permit(:data, :parent_comment_id, :user_id)
  end

end
