##
#   Vector2D is a basic data structure developed to store 2 dimensional
#   co-ordinates and allow them to be manipulated using addition, subtraction,
#   mulitplication and division.

module Tooled
  class Vector2D
    def initialize(x, y)
      @axis_values = [nil, nil]
      self.x, self.y = x.to_f, y.to_f
    end

    %w( x y ).each_with_index do |axis, i|
      define_method(axis) { @axis_values[i] }
      define_method("#{axis}=") { |val| @axis_values[i] = val.to_f }
    end

    %w( * / + - ).each do |sym|
      define_method(sym) { |val| _perform_message(val, sym) }
    end

    private

    def _perform_message(val, msg)
      if val.is_a?(Vector2D)
        Vector2D.new(x.send(msg, val.x), y.send(msg, val.y))
      else
        Vector2D.new(x.send(msg, val.to_f), y.send(msg, val.to_f))
      end
    end
  end
end
