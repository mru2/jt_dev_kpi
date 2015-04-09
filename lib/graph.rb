# Class for handling graphs
class Graph
  POINTS = 10 # Nb of points

  def initialize
    @points = (1..POINTS).map{|x| {:x => x, :y => 0} }
    @last_x = POINTS
  end

  def push(value)
    @points.shift
    @last_x += 1
    @points << {:x => @last_x, :y => value}
    {:points => @points}
  end
end
