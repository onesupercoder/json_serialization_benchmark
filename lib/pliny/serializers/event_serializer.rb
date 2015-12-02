require 'pliny/serializers/base'
require 'pliny/serializers/box_score_serializer'

module Sports::Serializers
  class Event < Base
    structure(:summary) do |event|
      summary_structure(event)
    end

    structure(:default) do |event|
      default_structure(event)
    end

    structure(:basketball) do |event|
      response = default_structure(event)
      response.merge!(
        important: event.important,
        location: event.location
      )

      response.merge!(away_ranking: event.away_ranking) if event.ncaa?
      response.merge!(away_region: event.away_region) if event.ncaa?
      response.merge!(home_ranking: event.home_ranking) if event.ncaa?
      response.merge!(home_region: event.home_region) if event.ncaa?
    end

    private

    def self.default_structure(event)
      summary_structure(event).merge(
        share_url: event.share_url,
        sport_name: event.sport_name,
        box_score: Sports::Serializers::BoxScore.new(:basketball).serialize(event.box_score)
      )
    end

    def self.summary_structure(event)
      {
        game_date: event.game_date,
        game_type: event.game_type,
        status: event.status,
        away_team: Sports::Serializers::Team.new(:basketball).serialize(event.away_team),
        home_team: Sports::Serializers::Team.new(:basketball).serialize(event.home_team)
      }
    end
  end
end
