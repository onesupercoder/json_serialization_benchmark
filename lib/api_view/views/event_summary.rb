
class EventSummaryApiView < ::ApiView::Base

  def self.convert(obj)
    hash = attrs(obj, :game_date, :game_type, :status)
    hash[:away_team] = BasketballTeamApiView.convert(obj.away_team)
    hash[:home_team] = BasketballTeamApiView.convert(obj.home_team)
    hash
  end

end
