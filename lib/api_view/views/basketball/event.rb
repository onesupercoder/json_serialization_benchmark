
require "api_view/views/event"

class BasketballEventApiView < EventApiView

  attributes :important, :location
  alias_method :event, :object

  def convert
    hash = super
    if event.ncaa? then
      hash[:away_ranking] = event.away_ranking
      hash[:away_region]  = event.away_region
      hash[:home_ranking] = event.home_ranking
      hash[:home_region]  = event.home_region
    end

    hash
  end

end
