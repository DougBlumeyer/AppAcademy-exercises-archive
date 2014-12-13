require 'byebug'

class Hangman
  attr_accessor :guesser, :checker, :board, :wrong_letters_guessed,
                :wrong_guesses_count

  def initialize(guesser, checker, max_wrong_guesses=8)
    @guesser = guesser
    @guesser.game = self

    @checker = checker
    @checker.game = self

    @winner = nil

    @max_wrong_guesses = max_wrong_guesses
    @wrong_guesses_count = 0

    @board = nil
    @wrong_letters_guessed = " "*26
  end

  def play
    game_setup

    until game_over?
      render_board
      puts "#{guesser.name}'s turn."
      guess = guesser.guess
      checker.check(guess)
    end

    game_over
  end

  def game_setup
    puts "Welcome to HANGMAN!\n"
    checker.pick_secret_word
    #puts "@game.board in game setup: #{@board}"
  end

  def game_over
    render_board
    puts "#{@winner} wins!"
  end

  def game_over?
    if @wrong_guesses_count == @max_wrong_guesses || \
      @wrong_letters_guessed == ('a'..'z').to_a
      @winner = @checker.name
      return true
    elsif !@board.include?("_")
      @winner = @guesser.name
      return true
    else
      false
    end
  end

  def render_board
    puts "\n"
    puts "#{@board}#{" "*(25-@board.length)}#{@wrong_guesses_count}/#{@max_wrong_guesses}"
    puts ""
    puts "[#{@wrong_letters_guessed}]"
    puts ""
  end

end

class ComputerPlayer
  attr_accessor :dictionary, :secret_word, :game, :name

  def initialize(name)
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @secret_word = nil
    @game = nil
    @name = name
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    puts "#{@secret_word}"
    @game.board = "_"*@secret_word.length
  end

  def guess
    attempt = ('a'..'z').to_a.sample
    until !@game.board.include?(attempt) && \
      !@game.wrong_letters_guessed.include?(attempt)
      attempt = ('a'..'z').to_a.sample
    end
    puts "#{@name} guesses '#{attempt}'."
    attempt
  end

  def check(guess)
    flag_at_least_one_match = false
    @secret_word.split("").each_with_index do |letter, i|
      if letter == guess
        @game.board[i] = letter
        flag_at_least_one_match = true
      end
    end
    unless flag_at_least_one_match
      @game.wrong_letters_guessed[guess.ord - 'a'.ord] = guess
      @game.wrong_guesses_count += 1
    end
  end

end

class HumanPlayer
  attr_accessor :game, :secret_word, :name, :flag_instructions_given

  def initialize(name)
    @game = nil
    @secret_word = nil
    @name = name
    @flag_instructions_given = false
  end

  def pick_secret_word
    print "What is the length of your secret word? "
    @secret_word = "_"*(gets.chomp.to_i)
    @game.board = @secret_word
  end

  def guess
    successful_input = false
    until successful_input
      print "Guess a letter: "
      input_attempt = gets.chomp
      if !('a'..'z').include?(input_attempt)
        puts "That's not a letter. Try again."
      elsif @game.board.include?(input_attempt)
        puts "You already found that one..."
      elsif @game.wrong_letters_guessed.include?(input_attempt)
        puts "You already tried that one..."
      else
        successful_input = true
      end
    end
    input_attempt
  end

  def check(guess)
    print "At which positions in your secret word does this letter occur? "
    unless @flag_instructions_given
      print "\nIf it occurs at more than one position, separate them with commas."
      print "\nFor example, \"1,4,5\"."
      print "\nJust push Return if it's not present. Please don't lie: "
    end

    successful_input = false
    until successful_input == true
      input_attempt = gets.chomp.split(",")

      if input_attempt.all? { |input| ('a'..'z').include?(input) }


        successful_input = true
        input_attempt.each do |input|

        end
      end

      puts "Something's not right with your input. Please try again." if successful_input
    end

  end

end

if __FILE__ == $PROGRAM_NAME
  hal = ComputerPlayer.new("HAL 9000")
  doug = HumanPlayer.new("Doug")
  #game = Hangman.new(doug,hal,5)  # human guesses
  game = Hangman.new(hal,doug,5) # computer guesses
  game.play
end
