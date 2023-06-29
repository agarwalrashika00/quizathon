module Quizathon

  class StatsManager

    attr_accessor :user_with_most_quiz, :highest_rated_quiz, :highest_scoring_participant, :commenting_user, :quizzes_with_participants_count

    def initialize(from, to)
      @from = from || 1.month.ago
      @to = to || Time.current
    end

    def fetch_stats
      fetch_user_with_most_quiz
      fetch_highest_rated_quiz
      fetch_highest_scoring_participant(2.month.ago..Time.current)
      fetch_commenting_user(Time.current.beginning_of_month..Time.current, 3)
      fetch_quizzes_with_participants_count
      self
    end

    private

    def fetch_user_with_most_quiz
      @user_with_most_quiz = QuizRunner.between(@from, @to).select(:user_id, 'count(*) AS quiz_count').group(:user_id).order(quiz_count: :desc).first.user
    end

    def fetch_highest_rated_quiz
      @highest_rated_quiz = Rating.select(:quiz_id, 'SUM(value) as total_rating').group(:quiz_id).order(total_rating: :desc).first.quiz
    end

    def fetch_highest_scoring_participant(time_range)
      @highest_scoring_participant = User.includes(:quizzes).joins(:quiz_runners).select(:id, :first_name, :last_name, 'SUM(score) AS total_score').where('quiz_runners.created_at': time_range).group(:id).order(total_score: :desc).first
    end

    def fetch_commenting_user(time_range, min_no_of_quizzes_commented)
      @commenting_user = User.joins(:comments).where(comments: {commentable_type: 'Quiz', created_at: time_range}).group(:id).having('count(distinct comments.commentable_id) >= ?', min_no_of_quizzes_commented).select('users.*, count(distinct comments.commentable_id) as total_quiz_comment').order(total_quiz_comment: :desc).first
    end

    def fetch_quizzes_with_participants_count
      @quizzes_with_participants_count = Quiz.joins(:quiz_runners).select('quizzes.*', 'COUNT(user_id) AS users_count').group(:id).order(users_count: :desc)
    end

  end

end
