module Basketball
  class PlayByPlayRecordMapping
    include Kartograph::DSL

    kartograph do
      mapping PlayByPlayRecord

      property :points_type,
               :player_fouls,
               :player_score,
               :record_type,
               :seconds,
               scopes: [:read, :basketball]
    end
  end
end
