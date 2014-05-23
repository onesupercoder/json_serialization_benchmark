
require "api_view/views/event"

class BasketballEventApiView < EventApiView

  def self.convert(event)
    hash = super.merge(
      important: event.important,
      location: event.location
    )

    if event.ncaa? then
      hash.merge!(
        away_ranking: event.away_ranking,
        away_region: event.away_region,
        home_ranking: event.home_ranking,
        home_region: event.home_region
      )
    end

    hash
  end

end
