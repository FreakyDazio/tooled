require "tooled/tree_node"

module Tooled
  class InvalidNodeException < Exception; end

  class TreeNodeCollection < ::Set
    def add(node)
      raise InvalidNodeException.new("Only TreeNode objects can be added to collection") unless node.is_a?(TreeNode)
      @hash[node] = true
      self
    end
    alias_method :<<, :add
  end
end
