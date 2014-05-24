
class EventSummaryApiView < ::ApiView::Base

  attributes :game_date, :game_type, :status

  def convert
    hash = super
    hash[:away_team] = BasketballTeamApiView.new(obj.away_team).convert
    hash[:home_team] = BasketballTeamApiView.new(obj.home_team).convert
    hash
  end

end
