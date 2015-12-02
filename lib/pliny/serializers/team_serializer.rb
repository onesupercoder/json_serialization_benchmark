require 'pliny/serializers/base'

module Sports::Serializers
  class Team < Base
    structure(:default) do |team|
      basic_structure(team)
    end

    structure(:basketball) do |team|
      basic_structure(team).merge(
        medium_name: team.medium_name,
        short_name: team.short_name
      )
    end

    private

    def self.basic_structure(team)
      {
        abbreviation: team.abbreviation,
        full_name: team.full_name,
        location: team.location
      }
    end
  end
end
