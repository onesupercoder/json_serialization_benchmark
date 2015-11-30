class TeamMapping
  include Kartograph::DSL

  kartograph do
    mapping Team

    property :abbreviation,
             :full_name,
             :location,
             scopes: [:read, :summary, :basketball]

    property :medium_name,
             :short_name,
             scopes: [:summary, :basketball]
  end
end
