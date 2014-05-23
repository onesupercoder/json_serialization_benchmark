
class BoxScoreApiView < ::ApiView::Base

  for_model ::BoxScore

  def self.convert(obj)
    attrs(obj, :has_statistics, :progress)
  end

end
