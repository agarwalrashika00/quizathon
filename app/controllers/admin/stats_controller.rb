class Admin::StatsController < Admin::BaseController

  def index
    @stats_manager = Quizathon::StatsManager.new(params[:from]&.to_time, params[:to]&.to_time&.+(1.day)).fetch_stats
  end

end
