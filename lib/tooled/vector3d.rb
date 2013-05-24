##
#   Vector3D is a basic data structure developed to store 3 dimensional
#   co-ordinates and allow them to be manipulated using addition, subtraction,
#   mulitplication and division.

module Tooled
  class Vector3D
    def initialize(x, y, z)
      @axis_values = [nil, nil, nil]
      self.x, self.y, self.z = x.to_f, y.to_f, z.to_f
    end

    %w( x y z ).each_with_index do |axis, i|
      define_method(axis) { @axis_values[i] }
      define_method("#{axis}=") { |val| @axis_values[i] = val.to_f }
    end

    %w( * / + - ).each do |sym|
      define_method(sym) { |val| _perform_message(val, sym) }
    end

    private

    def _perform_message(val, msg)
      if val.is_a?(Vector3D)
        Vector3D.new(x.send(msg, val.x), y.send(msg, val.y), z.send(msg, val.z))
      else
        Vector3D.new(x.send(msg, val.to_f), y.send(msg, val.to_f), z.send(msg, val.to_f))
      end
    end
  end
end
