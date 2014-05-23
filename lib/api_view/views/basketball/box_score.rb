
require "api_view/views/box_score"
require "api_view/views/basketball/play_by_play_record"

class BasketballBoxScoreApiView < BoxScoreApiView

  def self.convert(box_score)
    super.merge(
      attendance: box_score.attendance,
      referees: box_score.referees,
      last_play: render(box_score.last_play, :use => BasketballPlayByPlayRecordApiView)
    )
  end

end
