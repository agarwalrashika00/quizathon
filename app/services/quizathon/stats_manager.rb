module Quizathon

  class StatsManager

    attr_accessor :user_with_most_quiz, :highest_rated_quiz, :highest_scoring_participant, :quizzes_of_highest_scoring_participant, :commenting_user, :quiz_users_count_hash

    def initialize(from, to)
      @from = from || 1.month.ago
      @to = to || Time.current
    end

    def fetch_stats
      set_user_with_most_quiz
      set_highest_rated_quiz
      set_highest_scoring_participant
      set_commenting_user(Time.current.beginning_of_month..Time.current, 3)
      set_quizzes_with_participants_count
      self
    end

    private

    def set_user_with_most_quiz
      user_id = QuizRunner.between(@from, @to).select(:user_id, 'count(*) AS quiz_count').group(:user_id).order(quiz_count: :desc).first.user_id
      @user_with_most_quiz = User.find_by_id(user_id)
    end

    def set_highest_rated_quiz
      quiz_id = Rating.select(:quiz_id, 'SUM(value) as total_rating').group(:quiz_id).order(total_rating: :desc).first.quiz_id
      @highest_rated_quiz = Quiz.find_by_id(quiz_id)
    end

    def set_highest_scoring_participant
      user_id = QuizRunner.select(:user_id, 'SUM(score) AS total_score').group(:user_id).order(total_score: :desc).first.user_id
      @highest_scoring_participant = User.find_by_id(user_id)
      @quizzes_of_highest_scoring_participant = @highest_scoring_participant.quizzes.where(id: QuizRunner.where(created_at: 2.month.ago..Time.current).pluck(:quiz_id))
    end

    def set_commenting_user(time_range, min_no_of_quizzes_commented)
      user_id = Comment.where(created_at: time_range, commentable_type: 'Quiz').select(:user_id, 'COUNT (DISTINCT commentable_id) as quizzes_count').group(:user_id).having('COUNT (DISTINCT commentable_id) >= ?', min_no_of_quizzes_commented).order(quizzes_count: :desc).first&.user_id
      @commenting_user = User.find_by_id(user_id)
    end

    def set_quizzes_with_participants_count
      quiz_users_count_records = QuizRunner.select(:quiz_id, 'COUNT(user_id) AS users_count').group(:quiz_id).order(users_count: :desc)
      @quiz_users_count_hash = quiz_users_count_records.map { |record| [Quiz.find_by_id(record.quiz_id), record.users_count] }.to_h
    end

  end

end
