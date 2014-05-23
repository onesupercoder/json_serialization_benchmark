
require "api_view/views/event_summary"

class EventApiView < EventSummaryApiView

  for_model ::Event

  def self.convert(event)
    super.merge(
      share_url:  event.share_url,
      sport_name: event.sport_name,
      box_score:  render(event.box_score, :use => BasketballBoxScoreApiView)
    )
  end

end
