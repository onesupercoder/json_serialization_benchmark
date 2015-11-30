require 'kartograph'

require 'kartograph/mappings/box_score_mapping'
require 'kartograph/mappings/event_mapping'
require 'kartograph/mappings/team_mapping'

require 'kartograph/mappings/basketball/play_by_play_record_mapping'

class OjWrapper
  def self.dump(object)
    Oj.dump(object, mode: :compat)
  end

  def self.load(object)
    Oj.load(object, mode: :strict)
  end
end

Kartograph.default_loader = OjWrapper
Kartograph.default_dumper = OjWrapper