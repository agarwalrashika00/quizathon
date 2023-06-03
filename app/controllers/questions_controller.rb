class QuestionsController < ApplicationController

  before_action :set_quiz
  before_action :set_question
  before_action :set_quiz_runner
  before_action :set_quiz_question

  def show
    if @quiz_runner.status == 'completed'
      redirect_to quiz_path(@quiz), alert: 'You have already attempted the quiz once.'
    else
      @remaining_time = (@quiz.time_limit_in_seconds - (Time.now - session[:start_time].to_time).to_i)
      if @remaining_time < 0
        redirect_to submit_quiz_path(@quiz), alert: 'Time is over. Submmit the quiz now.'
      end
      @user_solution = UserSolution.find_or_initialize_by(user: current_user, quiz_question_id: @quiz_question.id)
    end
  end

  def submit
    user_solution = Quizathon::ResponsesController.new(current_user, @quiz_question).submit(marked_option_id)
    next_question_slug = @quiz_runner.find_next_slug(@question.slug)
    if user_solution.errors.blank?
      if next_question_slug.present?
        redirect_to question_path(@quiz, question_slug: next_question_slug)
      else
        redirect_to submit_quiz_path(@quiz)
      end
    else
      redirect_to question_path(@quiz, question_slug: @question.slug), notice: user_solution.errors.to_a
    end
  end

  def previous
    previous_question_slug = @quiz_runner.find_previous_slug(@question.slug)
    if previous_question_slug.present?
      redirect_to question_path(@quiz, question_slug: previous_question_slug)
    else
      redirect_to question_path(@quiz, question_slug: @question.slug), notice: 'You are already on first question.'
    end
  end

  def next
    next_question_slug = @quiz_runner.find_next_slug(@question.slug)
    if next_question_slug.present?
      redirect_to question_path(@quiz, question_slug: next_question_slug, quiz_runner_id: @quiz_runner.id)
    else
      redirect_to submit_quiz_path(@quiz, quiz_runner_id: @quiz_runner.id)
    end
  end

  private

  def set_quiz
    unless @quiz = Quiz.find_by_slug(params[:slug])
      redirect_to quizzes_path, alert: 'Quiz doesnot exist'
    end
  end

  def set_question
    unless @question = Question.find_by_slug(params[:question_slug])
      redirect_to quizzes_path, alert: 'Question doesnot exist'
    end
  end

  def set_quiz_runner
    unless @quiz_runner = QuizRunner.find_by_id(session[:quiz_runner_id])
      redirect_to quizzes_path, alert: 'Quiz runner doesnot exist'
    end
  end

  def set_quiz_question
    @quiz_question = QuizQuestion.find_by(quiz_id: @quiz.id, question_id: @question.id)
  end

  def marked_option_id
    params[:user_solution][:marked_option_id]
  end

end
