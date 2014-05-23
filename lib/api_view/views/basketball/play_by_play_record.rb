
class BasketballPlayByPlayRecordApiView < ::ApiView::Base

  def self.convert(obj)
    attrs(obj, :points_type, :player_fouls, :player_score, :record_type, :seconds)
  end

end
