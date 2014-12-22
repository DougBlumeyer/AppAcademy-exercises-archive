require 'colorize'

class Board
  attr_accessor :cursor, :is_over

  def initialize(size = 9, difficulty = 5)
    @size = size
    @difficulty = difficulty
    @tiles = Array.new(size) { Array.new(size) { Tile.new } }
    @is_over = false
    @cursor = [@size / 2, @size / 2]
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @tiles[x][y]
  end

  def set_bomb(pos)
    self[pos].is_bomb = true
  end

  def change_mark(pos)
    unless self[pos].is_revealed
      if self[pos].mark == :unmarked
        self[pos].mark = :marked
      elsif self[pos].mark == :marked
        self[pos].mark = :unsure
      elsif self[pos].mark == :unsure
        self[pos].mark = :unmarked
      end
    end
  end

  def reveal(pos)
    queue = [pos]
    until queue.empty?
      current_pos = queue.shift
      if self[current_pos].is_bomb
        self.is_over = true
      elsif self[current_pos].is_revealed
        neighbors(current_pos).each do |neighbor|
          if neighbor.is_bomb
            self.is_over = true
          else
            neighbor.is_revealed = true
          end
        end
      else
        unless self[current_pos].is_revealed ||
          self[current_pos].mark != :unmarked
          self[current_pos].is_revealed = true
          if self[current_pos].bomb_count == 0
            neighbors(current_pos).each do |neighbor|
              queue << neighbor
            end
          end
        end
      end
    end
  end

  def move(x_offset, y_offset)
    new_pos = [@cursor[0] + x_offset, @cursor[1] + y_offset]
    @cursor = new_pos if on_board?(new_pos)
  end

  def on_board?(pos)
    x, y = pos[0], pos[1]
    x.between?(0, @size - 1) && y.between?(0, @size - 1)
  end

  def neighbors(pos)
    neighbors = []
    x, y = pos[0], pos[1]
    (-1..1).each do |x_offset|
      (-1..1).each do |y_offset|
        neighbor_pos = [x + x_offset, y + y_offset]
        if !(x_offset == 0 && y_offset == 0) && on_board?(neighbor_pos)
          neighbors << neighbor_pos
        end
      end
    end
    neighbors
  end

  def show
    system("clear")
    @tiles.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        #setpos(x,y*2)
        if @cursor == [x,y]
          if is_over
            print "X ".colorize(:light_white).on_light_black #addstr("X")
          else
            print "\u2316 ".colorize(:light_white).on_light_black #addstr("#")
          end
        elsif tile.mark == :marked
          if is_over
            print "X ".colorize(:light_magenta).on_light_black #addstr("X")
          else
            print "\u2691 ".colorize(:white).on_light_black #addstr("F")
          end
        elsif tile.mark == :unsure
          if is_over
            print "X ".colorize(:light_magenta).on_light_black #addstr("X")
          else
            print "? ".colorize(:light_black).on_light_black #addstr("?")
          end
        elsif tile.is_revealed
          if tile.bomb_count == 0
            print "_ ".colorize(:light_black).on_light_black #addstr("_")
          else
            show_number(tile) #addstr("#{tile.bomb_count}")
          end
        elsif tile.is_bomb
          if is_over
            print "\u2735 ".colorize(:light_yellow).on_light_black #addstr("B")
          else
            print "` ".colorize(:light_black).on_light_black #addstr("`")
          end
        else
          print "` ".colorize(:light_white).on_light_black #addstr("`")
        end
      end
      print "\n"
    end
    #refresh
  end

  def show_number(tile)
    color_sym =
    case tile.bomb_count
    when 1
      :light_blue
    when 2
      :green
    when 3
      :light_red
    when 4
      :blue
    when 5
      :red
    when 6
      :cyan
    when 7
      :magenta
    when 8
      :yellow
    end
    print "#{tile.bomb_count} ".colorize(color_sym).on_light_black
  end

  def place_bombs
    @difficulty.times do
      bomb_placed = false
      until bomb_placed
        rand_x = rand(@size)
        rand_y = rand(@size)
        unless self[[rand_x, rand_y]].is_bomb
          set_bomb([rand_x,rand_y])
          bomb_placed = true
        end
      end
    end
  end

  def each_position()
    0.upto(@size - 1) do |x|
      0.upto(@size - 1) do |y|
        yield [x, y]
      end
    end
  end

  def set_bomb_counts
    each_position do |current_pos|
      current_tile = self[current_pos]
      neighbors(current_pos).each do |pos|
        if self[pos].is_bomb
          current_tile.bomb_count += 1
        end
      end
    end
  end

  def board_won?
    no_unmarked_or_unrevealed_tiles? && no_false_marks?
  end

  def no_unmarked_or_unrevealed_tiles?
    each_position do |pos|
      if self[pos].mark != :marked && !self[pos].is_revealed
        return false
      end
    end

    true
  end

  def no_false_marks?
    each_position do |pos|
      if self[pos].mark == :marked && !self[pos].is_bomb
        return false
      end
    end

    true
  end

end
