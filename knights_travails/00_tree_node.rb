module Ptn

  class PolyTreeNode

    def initialize(value)
      @value = value
      @children = []
      @parent = nil
    end

    def parent
      @parent
    end

    def parent=(node)
      @parent.children.delete(self) unless @parent.nil?

      @parent = node

      node.children << self unless node.nil? || node.children.include?(self)
    end

    def children
      @children
    end

    def value
      @value
    end

    def add_child(node)
      node.parent = self unless node.nil? || @children.include?(node)
    end

    def remove_child(node)
      raise "Wasn't a child in the first place! " if !@children.include?(node)
      node.parent = nil unless node.nil?
    end

    def dfs(target)
      return self if value == target

      children.each do |child|
        node = child.dfs(target)
        return node if node
      end

      nil
    end

    def bfs(target)
      queue = [self]
      until queue.empty?
        shifted_node = queue.shift
        return shifted_node if shifted_node.value == target
        queue += shifted_node.children unless shifted_node.nil?
      end
      nil
    end

  end
end
