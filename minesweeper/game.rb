#require 'curses'
#include Curses
require 'YAML'
require 'io/console'
require_relative 'tile.rb'
require_relative 'board.rb'

class Minesweeper
  attr_accessor :board, :size, :mines

  def play
    welcome

    until board.is_over
      board.is_over = board.board_won?
      board.show
      #puts "w9290295209"
      input(read_char)
    end

    board.show
    #input(getch)
  end

  def welcome
    #init_screen
    #crmode
    # setpos(3,3)
    # addstr("Welcome to Minesweeper! ")
    # setpos(4,3)
    # addstr("w/a/s/d to move. f to flag. r to reveal. q to quit.")
    # setpos(5,3)
    # addstr("k to save. l to load.")
    # setpos(7,3)
    # addstr("How big of a field would you like? (s,m,l,x) " )
    puts "Welcome to Minesweeper! "
    puts "w/a/s/d to move. f to flag. r to reveal. q to quit."
    puts "k to save. l to load."
    print "How big of a field would you like? (s,m,l,x): "
    s_i = read_char
    puts s_i
    size_input(s_i)
    #setpos(8,3)
    print "And how many mines would you like? "
    # addstr("And how many mines would you like? ")
    mines_input
    #clear()
  end

  def size_input(input_size)
    case input_size
    when 's'
      self.size = 9
    when 'm'
      self.size = 16
    when 'l'
      self.size = 25
    when 'x'
      self.size = 36
    end
  end

  def mines_input
    mines_str = ""
    loop do
      input = read_char
      print input
      if input == "\r"
        #puts "HEOIEGOJE"
        break
      end
      mines_str << input
    end
    @board = Board.new(size, mines_str.to_i)
    #puts "zzzzzzzzzzzzzzzzzzzz"
    board.place_bombs
    board.set_bomb_counts
  end

  def input(key)
    case key
    when 'w'
      board.move(-1,0)
    when "a"
      board.move(0,-1)
    when "s"
      board.move(1,0)
    when "d"
      board.move(0,1)
    when 'f'
      board.change_mark(board.cursor)
    when 'r'
      board.reveal(board.cursor)
    when 'k'
      File.open("minesweeper_#{Time.now}.yml", "w") do |f|
        f.puts self.to_yaml
      end
    when 'l'
      File.open(gets.chomp) do |f|
        self.board = YAML.load(f).board
      end
    when 'q'
      exit
    end
  end

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


if __FILE__ == $PROGRAM_NAME
  ms = Minesweeper.new.play
end

#add ? functionality DONE
#add reveal on a number functionality
#add colorize DOESNT WORK WITH CURSES SO I SWITCHED IT
#add adjust size and difficulty DONE
#have it reveal the rest of the board if you flag everything
