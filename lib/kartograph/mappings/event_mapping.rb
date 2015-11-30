require 'kartograph/mappings/box_score_mapping'
require 'kartograph/mappings/team_mapping'

class EventMapping
  include Kartograph::DSL

  kartograph do
    mapping Event

    property :game_date,
             :game_type,
             :status,
             scopes: [:read, :summary, :basketball]

    property :away_team, include: TeamMapping, scopes: [:read, :summary, :basketball]
    property :home_team, include: TeamMapping, scopes: [:read, :summary, :basketball]

    property :share_url,
             :sport_name,
             scopes: [:read, :basketball]

    property :box_score, include: BoxScoreMapping, scopes: [:read, :basketball]

    property :important,
             :location,
             scopes: [:basketball]

    # TODO this isn't equal to the other serializers which only include these
    # keys if the event's `ncaa?` is truthy
    property :away_ranking,
             :away_region,
             :home_ranking,
             :home_region,
             scopes: [:basketball]
  end
end

