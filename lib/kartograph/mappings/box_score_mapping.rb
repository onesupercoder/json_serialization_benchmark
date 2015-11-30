require 'kartograph/mappings/basketball/play_by_play_record_mapping'

class BoxScoreMapping
  include Kartograph::DSL

  kartograph do
    mapping BoxScore

    property :has_statistics,
             :progress,
             scopes: [:read, :basketball]

    property :attendance,
             :referees,
             scopes: [:basketball]

    property :last_play, incude: Basketball::PlayByPlayRecordMapping, scopes: [:basketball]
  end
end
