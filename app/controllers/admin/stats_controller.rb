class Admin::StatsController < Admin::BaseController

  def index
    @stats_controller = Quizathon::StatsController.new
    @stats_controller.set_user_with_most_quiz(params[:from]&.to_time, params[:to]&.to_time&.+(1.day))
    @stats_controller.set_highest_rated_quiz
    @stats_controller.set_highest_scoring_participant
    @stats_controller.set_commenting_user(Time.current.beginning_of_month..Time.current, 3)
    @stats_controller.set_quizzes_with_participants_count
  end

end
