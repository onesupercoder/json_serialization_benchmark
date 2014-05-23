
class EventSummaryApiView < ::ApiView::Base

  def self.convert(obj)
    hash = attrs(obj, :game_date, :game_type, :status)
    hash[:away_team] = render(obj.away_team, :use => BasketballTeamApiView)
    hash[:home_team] = render(obj.home_team, :use => BasketballTeamApiView)
    hash
  end

end
