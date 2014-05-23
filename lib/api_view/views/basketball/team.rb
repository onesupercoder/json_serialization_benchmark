
require "api_view/views/team"

class BasketballTeamApiView < TeamApiView

  def self.convert(team)
    hash = super
    hash[:medium_name] = team.medium_name
    hash[:short_name]  = team.short_name
    hash
  end

end
