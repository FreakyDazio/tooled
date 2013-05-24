##
#   Queue provides a first on, first off array

module Tooled
  class Queue
    include Enumerable

    def initialize
      @queue_values = []
    end

    def count
      @queue_values.count
    end
    alias_method :length, :count

    def <<(value)
      @queue_values << value
    end
    alias_method :push, :<<

    def peek
      @queue_values.first
    end

    def pop
      @queue_values.delete_at(0)
    end

    def [](index)
      @queue_values[index.to_i]
    end

    def to_a
      @queue_values.reverse.dup
    end

    def empty?
      @queue_values.empty?
    end

    def each(&block)
      yield block.call(pop) until empty?
    end
  end
end
