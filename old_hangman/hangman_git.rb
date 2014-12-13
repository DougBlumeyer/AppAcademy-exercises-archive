class Hangman
  attr_accessor :guesser, :checker

  def initialize(guesser, checker, max_wrong_guesses=8)
    @guesser = guesser
    @checker = checker
    @max_wrong_guesses = max_wrong_guesses
    @wrong_guesses
    @secret_word = nil
  end

  def play
    game_setup

    until game_over?
      render_board
      guesser.guess
      checker.check
    end

    game_over
  end

  def game_setup
    puts "Welcome to HANGMAN!"
    checker.pick_secret_word
  end

  def game_over
    render_board
    puts "#{winner} wins!"
  end

  def game_over?
    @wrong_guesses == @max_wrong_guesses ? true : false
  end

  def render_board
  end
end

class Player
end

class ComputerPlayer < Player
  def initialize
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @secret_word = nil
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    puts "#{@secret_word}"
  end
end

class HumanPlayer < Player

end

if __FILE__ == $PROGRAM_NAME
  hal = ComputerPlayer.new
  doug = HumanPlayer.new
  game = Hangman.new(doug,hal,5)
  game.play
end
