require 'pliny/serializers/base'
require 'pliny/serializers/basketball/play_by_play_record_serializer'

module Sports::Serializers
  class BoxScore < Base
    structure(:default) do |box_score|
      basic_structure(box_score)
    end

    structure(:basketball) do |box_score|
      basic_structure(box_score).merge(
        attendance: box_score.attendance,
        referees: box_score.referees,
        last_play: Sports::Serializers::Basketball::PlayByPlayRecord.new(:default).serialize(box_score.last_play)
      )
    end

    private

    def self.basic_structure(box_score)
      {
        has_statistics: box_score.has_statistics,
        progress: box_score.progress
      }
    end
  end
end
