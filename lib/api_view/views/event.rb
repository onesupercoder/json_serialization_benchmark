
require "api_view/views/event_summary"

class EventApiView < EventSummaryApiView

  for_model ::Event

  def self.convert(event)
    hash = super
    hash[:share_url] = event.share_url
    hash[:sport_name] = event.sport_name
    hash[:box_score] = BasketballBoxScoreApiView.convert(event.box_score)
    hash
  end

end
