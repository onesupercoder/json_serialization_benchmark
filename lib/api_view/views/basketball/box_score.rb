
require "api_view/views/box_score"
require "api_view/views/basketball/play_by_play_record"

class BasketballBoxScoreApiView < BoxScoreApiView

  def self.convert(box_score)
    hash = super
    hash[:attendance] = box_score.attendance,
    hash[:referees] = box_score.referees,
    hash[:last_play] = render(box_score.last_play, :use => BasketballPlayByPlayRecordApiView)
    hash
  end

end
