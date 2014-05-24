
require "api_view/views/box_score"
require "api_view/views/basketball/play_by_play_record"

class BasketballBoxScoreApiView < BoxScoreApiView

  attributes :attendance, :referees
  alias_method :box_score, :object

  def convert
    hash = super
    hash[:last_play] = BasketballPlayByPlayRecordApiView.new(box_score.last_play).convert
    hash
  end

end
