
require "api_view/views/event_summary"

class EventApiView < EventSummaryApiView

  for_model ::Event

  def self.convert(event)
    hash = super
    hash[:share_url] = event.share_url
    hash[:sport_name] = event.sport_name
    hash[:box_score] = render(event.box_score, :use => BasketballBoxScoreApiView)
    hash
  end

end
