class Tile
  attr_accessor :is_bomb, :mark, :bomb_count, :is_revealed

  def initialize(is_bomb = false, mark = :unmarked, bomb_count = 0, is_revealed = false)
    @is_bomb = is_bomb
    @mark = mark
    @is_revealed = is_revealed
    @bomb_count = bomb_count
  end

end
