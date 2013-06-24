require "tooled/tree_node_collection"

module Tooled
  class TreeNode
    def initialize
      @children = TreeNodeCollection.new
      @parent = nil
    end

    def children
      @children
    end

    def parent
      @parent
    end

    def parent=(node)
      raise InvalidNodeException.new("`parent' can only sbe a TreeNode") unless node.is_a?(TreeNode)
      @parent = node.tap { |n| n.children.add(self) }
    end
  end
end
