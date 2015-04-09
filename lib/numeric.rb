# Class for handling numeric values
class Numeric
  def initialize
    @last = 0
    @current = 0
  end

  def push(value)
    @last = @current
    @current = value

    {:last => @last, :current => @current}
  end
end