
require "api_view/views/team"

class BasketballTeamApiView < TeamApiView

  def self.convert(team)
    super.merge(
      medium_name: team.medium_name,
      short_name: team.short_name
    )
  end

end
