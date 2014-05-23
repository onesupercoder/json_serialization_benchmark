
class TeamApiView < ::ApiView::Base

  for_model ::Team

  def self.convert(obj)
    hash = attrs(obj, :abbreviation, :full_name, :location)
  end

end
