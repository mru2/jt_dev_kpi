# Class for handling graphs
class Graph
  def initialize(points = 10)
    @points = (1..points).map{|x| {:x => x, :y => 0} }
    @last_x = points
  end

  def push(value)
    @points.shift
    @last_x += 1
    @points << {:x => @last_x, :y => value}
    {:points => @points}
  end
end
