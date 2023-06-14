class RatingsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ratings"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
