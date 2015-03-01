require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'errors.rb'
require 'io/console'
require 'pry'

class Game
  attr_accessor :grabbed, :turn, :board #just had to make an accessor for pry testing

  def initialize
    @grabbed = []
    @turn = :top
  end

  def setup
    system("clear")
    puts "Welcome to Checkers!"
    print "Top, what color would you like to be? "
    top_color = gets.chomp
    print "Bottom, what color would you like to be? "
    bottom_color = gets.chomp
    @board = Board.new(top_color.to_sym, bottom_color.to_sym, true, self)
  end

  def play
    setup

    until board.is_over
      puts "\nhere's the board that the real game is in:"
      puts board
      puts "here's our piece: #{board[[2,2]]}"
      #p board
      board.render
      begin
        input(read_char)
      rescue InvalidActionError
        self.grabbed = []
        retry
      rescue InvalidMoveError
        self.grabbed = []
        retry
      end
    end

    board.render
  end

  def input(key)
    case key
    when "\e[A"
      board.cursor[0] -= 1 if board.cursor[0] > 0
    when "\e[D"
      board.cursor[1] -= 1 if board.cursor[1] > 0
    when "\e[B"
      board.cursor[0] += 1 if board.cursor[0] < 7
    when "\e[C"
      board.cursor[1] += 1 if board.cursor[1] < 7
    when "\r"
      attempt_action
    when "\e"
      exit
    end
  end

  def attempt_action
    if grabbed.empty?
      grab
    else
      if a_jump?(grabbed.last, board.cursor)
        puts "trying to jump"
        grabbed << board.cursor.dup
        puts "here's grabbed so far: #{grabbed}"
        jump_if_seq_complete
      else
        puts "trying to slide"
        slide
      end
    end
  end

  def grab
    raise InvalidActionError.new "No piece there!" if board[board.cursor].nil?
    raise InvalidActionError.new "Not your piece!" if board[board.cursor].side != turn
    self.grabbed = [board.cursor.dup]
    puts "here's what self.grabbed is: #{self.grabbed}"
  end

  def slide
    raise InvalidActionError.new "Must jump if possible!" if side_could_jump
    #board[grabbed.pop].perform_slide(board.cursor)
    #so board.cursor isn't a piece...
    puts "here's what board[grabbed.pop] is, probably the thing that's going to move: #{board[grabbed.last]}"
    puts "and at this point this is what game.grabbed, well just grabbed here, is: #{grabbed}"
    puts "\n   okay, grabbed is being lost RIGHT here. board[grabbed]... okay i just took away the pop and put a reset to [] afterwards like it was in jump_if_seq_complete"
    board[grabbed.last].perform_moves([board.cursor])
    self.grabbed = []
    toggle_turn
  end

  def jump_if_seq_complete
      duped_board = board.dup
      puts "hmm did this duping really work?"
      p duped_board
      duped_board[grabbed.first].perform_moves!([grabbed.last], duped_board)
      puts "duped_board[grabbed.last].jump_set (is it []? then done with this jump seq): #{duped_board[grabbed.last].jump_set}"
      return unless duped_board[grabbed.last].jump_set == []

    #if board[grabbed.first].jump_seqs.include?(grabbed.drop(1))
      #board[grabbed.first].perform_jump(grabbed.drop(1))
      puts "checking to see if grabbed.last is still a thing: #{grabbed.last}"
      puts "here's what we're about to pop: #{board[grabbed.first]}"
      puts "uhhh okay wtf is the board right now:"
      p board
      puts "and yet WTF board[3,1] is #{board[[3,1]]} just like it should be"
      puts "also just curious what is grabbed drop 1 btw: #{grabbed.drop(1)}"
      jumping_piece = board[grabbed.first]
      jumping_piece.perform_moves([grabbed.drop(1)], board)
      self.grabbed = []
      toggle_turn
    #end
  end

  def side_could_jump
    board.all_piece_pos(board[grabbed.first].side).each do |piece|
      return true unless board[piece].jump_set == []
    end

    false
  end

  def a_jump?(from, to)
    (from[0] - to[0]).abs == 2
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!
    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!
    return input
  end

  def toggle_turn
    self.turn = ( turn == :top ? :bottom : :top )
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new.play
end

g = Game.new
g.board = Board.new(:yellow, :green, true, g)


binding.pry
