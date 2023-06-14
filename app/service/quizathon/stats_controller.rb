module Quizathon

  class StatsController

    attr_accessor :user_with_most_quiz, :highest_rated_quiz, :highest_scoring_participant, :quizzes_of_highest_scoring_participant, :commenting_user, :reverse_quiz_count_hash

    def set_user_with_most_quiz(from, to)
      from ||= 1.month.ago
      to ||= Time.current
      user_quiz_count_hash = QuizRunner.between(from, to).select(:user_id).group(:user_id).count
      user_id = user_quiz_count_hash.key(user_quiz_count_hash.values.max)
      @user_with_most_quiz = User.find_by_id(user_id)
    end

    def set_highest_rated_quiz
      quiz_rating_count_hash = Rating.select(:quiz_id).group(:quiz_id).sum(:rating)
      quiz_id = quiz_rating_count_hash.key(quiz_rating_count_hash.values.max)
      @highest_rated_quiz = Quiz.find_by_id(quiz_id)
    end

    def set_highest_scoring_participant
      user_total_score_hash = QuizRunner.select(:user_id).group(:user_id).sum(:score)
      user_id = user_total_score_hash.key(user_total_score_hash.values.max)
      @highest_scoring_participant = User.find_by_id(user_id)
      @quizzes_of_highest_scoring_participant = Quiz.where(id: QuizRunner.where(created_at: 2.month.ago..Time.current, user_id: user_id).pluck(:quiz_id))
    end

    def set_commenting_user(time_range, min_no_of_quizzes_commented)
      commmenting_user_ids = Comment.where(created_at: time_range).where(commentable_type: 'Quiz').order(created_at: :desc).pluck(:user_id, :commentable_id).uniq.map(&:first)
      user_comments_count_hash = commmenting_user_ids.uniq.map{ |v| [v, commmenting_user_ids.count(v)]}.to_h
      user_id = user_comments_count_hash.key(user_comments_count_hash.values.max) if user_comments_count_hash.values.max >= min_no_of_quizzes_commented
      @commenting_user = User.find_by_id(user_id)
    end

    def set_quizzes_with_participants_count
      @reverse_quiz_count_hash = QuizRunner.select(:quiz_id).group(:quiz_id).count.sort_by{ |k, v| v }.reverse
    end

  end

end
