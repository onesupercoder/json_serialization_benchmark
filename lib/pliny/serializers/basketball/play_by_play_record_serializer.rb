require 'pliny/serializers/base'

module Sports::Serializers::Basketball
  class PlayByPlayRecord < Sports::Serializers::Base
    structure(:default) do |box_score|
      {
        points_type: box_score.points_type,
        player_fouls: box_score.player_fouls,
        player_score: box_score.player_score,
        record_type: box_score.record_type,
        seconds: box_score.seconds
      }
    end
  end
end
