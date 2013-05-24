##
#   Stack provides a first on, last off array

module Toolbox
  class Stack
    include Enumerable

    def initialize
      @stack_values = []
    end

    def count
      @stack_values.count
    end
    alias_method :length, :count

    def <<(value)
      @stack_values << value
    end
    alias_method :push, :<<

    def peek
      @stack_values.last
    end

    def pop
      @stack_values.delete_at(@stack_values.count - 1)
    end

    def [](index)
      @stack_values[@stack_values.count - (index.to_i + 1)]
    end

    def to_a
      @stack_values.dup
    end

    def empty?
      @stack_values.empty?
    end

    def each(&block)
      yield block.call(pop) until empty?
    end
  end
end
