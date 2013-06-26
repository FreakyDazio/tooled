require "tooled/tree_node_collection"

module Tooled
  class TreeNode
    def initialize
      @children = TreeNodeCollection.new
      parent = nil
    end

    def children
      @children
    end

    def each_child
      return to_enum(:each_child) unless block_given?
      children.each do |child|
        yield child
        child.each_child { |c| yield c }
      end
    end

    def parent
      @parent
    end

    def descendants
      enum = to_enum(:each_child)
      TreeNodeCollection.new(enum.respond_to?(:lazy) ? enum.lazy : enum)
    end

    def ancestors
      enum = ::Enumerator.new do |yielder|
        parent_node = parent
        while parent_node
          yielder << parent_node
          parent_node = parent_node.parent
        end
      end
      TreeNodeCollection.new(enum.respond_to?(:lazy) ? enum.lazy : enum)
    end

    def parent=(node)
      raise InvalidNodeException.new("`parent' can only be a TreeNode") unless node.is_a?(TreeNode)
      raise InvalidNodeException.new("`parent' can not be a descendant") if descendants.member?(node)
      @parent = node.tap { |n| n.children.add(self) }
    end
  end
end
