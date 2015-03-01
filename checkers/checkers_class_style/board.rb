require 'colorize'

class Board
  attr_reader :side_colors
  attr_accessor :cursor, :game

  def initialize(top_color, bottom_color, fill_board = false, game)
    @grid = Array.new(8) { Array.new(8) }

    @game = game
    puts "Hi I'm initializing the board. Here is the board's game: #{@game}"

    return unless fill_board
    populate(:top, top_color)
    populate(:bottom, bottom_color)

    @side_colors = { top: top_color, bottom: bottom_color}

    @cursor = [4, 4]


  end

  def self.on_board?(pos)
    r, c = pos
    r.between?(0, 7) && c.between?(0, 7)
  end

  def dup
    duped_board = Board.new(side_colors[:top], side_colors[:bottom], false, game)
    (0..7).each do |r|
      (0..7).each do |c|
        next if self[[r, c]].nil?
        #puts "copying a piece into #{r}, #{c}"
        piece = self[[r, c]]
        duped_board[[r, c]] = piece.dup
        duped_board[[r, c]].board = duped_board
        duped_board[[r, c]].game = game
        duped_board.cursor = cursor.dup
      end
    end

    duped_board
  end

  def inspect
    (0..7).each do |r|
      (0..7).each do |c|
        if self[[r,c]].nil?
          print "[#{r},#{c}] "
        else
          print "#{self[[r,c]].side} "
        end
      end
      print "\n"
    end
  end

  def all_pos
    [0,1,2,3,4,5,6,7].repeated_permutation(2).to_a
  end

  def populate(side, color)
    anchor_r = ( side == :top ? 0 : 5 )
    (anchor_r..anchor_r + 2).each do |r|
      (0..7).each do |c|
        if (r + c) % 2 == 0
          self[[r, c]]= Piece.new(self, side, [r, c], game)
          puts "here's a piece's game: #{self[[r, c]].game}"
        end
      end
    end
  end

  def [](pos)
    r, c = pos
    @grid[r][c]
  end

  def []=(pos, piece)
    r, c = pos
    @grid[r][c] = piece
  end

  def unoccupied?(pos)
    self[pos].nil?
  end

  def occupied_by?(side, pos)
    return false if self[pos].nil?
    self[pos].side == side
  end

  def other_side(side)
    side == :top ? :bottom : :top
  end

  def all_piece_pos(side)
    all_pos.select { |pos| !self[pos].nil? && self[pos].side == side }
  end

  def render
    system("clear")
    (0..7).each do |r|
      (0..7).each do |c|
        if self[[r, c]].nil?
          render_square_empty(r, c)
        else
          render_square_with_piece(r, c)
        end
      end
      print "\n"
    end
  end

  def render_square_empty(r,c)
    if cursor == [r, c]
      if (r + c) % 2 == 0
        print " ".colorize(:black).on_white
      else
        print " ".colorize(:white).on_light_white
      end
    else
      if (r + c) % 2 == 0
        print " ".colorize(:black).on_black
      else
        print " ".colorize(:white).on_light_black
      end
    end
  end

  def render_square_with_piece(r, c)
    if cursor == [r, c]
      if (r + c) % 2 == 0
        print "#{self[[r,c]].symbol.encode('utf-8')}"
        .colorize(side_colors[self[[r,c]].side]).on_white
      else
        print "#{self[[r,c]].symbol.encode('utf-8')}"
        .colorize(side_colors[self[[r,c]].side]).on_light_white
      end
    else
      if (r + c) % 2 == 0
        print "#{self[[r,c]].symbol.encode('utf-8')}"
        .colorize(side_colors[self[[r,c]].side]).on_black
      else
        print "#{self[[r,c]].symbol.encode('utf-8')}"
        .colorize(side_colors[self[[r,c]].side]).on_light_black
      end
    end
  end

  def is_over
    top_lost || bottom_lost
  end

  def top_lost
    all_piece_pos(:top).empty?
  end

  def bottom_lost
    all_piece_pos(:bottom).empty?
  end
end
