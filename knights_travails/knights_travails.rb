require './00_tree_node.rb'

class KnightPathFinder
  attr_accessor :visited_positions, :start_pos, :parent_node

  def initialize(start_pos)
    @start_pos = start_pos
    @visited_positions = [start_pos]
  end

  def self.valid_moves(pos)
    offsets = [-2, -1, 1, 2].permutation(2)
      .reject { |perm| perm.inject(:+) == 0 }

    moves = offsets.map { |offset| [pos[0] + offset[0], pos[1] + offset[1]] }
    moves.select { |move| move.all? { |m| m.between?(0, 7) } }
  end

  def new_move_positions(pos)
    new_moves = KnightPathFinder.valid_moves(pos).reject do |valid_move|
      @visited_positions.include?(valid_move)
    end

    @visited_positions += new_moves
    new_moves
  end

  def find_path(end_pos)
    trace_path_back(@parent_node.dfs(end_pos))
  end

  def trace_path_back(node)
    return [@start_pos] if node.parent.nil?
    [node.value] + trace_path_back(node.parent)
  end

  def build_move_tree
    @parent_node = PolyTreeNode.new(@start_pos)
    queue = [@parent_node]

    until queue.empty?
      current_node = queue.shift
      new_move_positions(current_node.value).each do |new_move_position|
        child_node = PolyTreeNode.new(new_move_position)
        current_node.add_child(child_node)
        queue += [child_node]
      end
    end
  end
end
