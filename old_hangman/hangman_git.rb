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

      positions = checker.check(guess)
      puts "do we have any positions here? #{positions}"
      #debugger
      guesser.learn_from_guess(guess, positions)
    end

    game_over
  end

  def game_setup
    system("clear")
    puts "\n\nWelcome to HANGMAN!\n\n"

    set_max_wrong_guesses

    checker.pick_secret_word
  end

  def set_max_wrong_guesses
    print "How many wrong guesses allowed this round? "
    @max_wrong_guesses = gets.chomp.to_i

    until @max_wrong_guesses > 0
      print "Huh? "
      @max_wrong_guesses = gets.chomp.to_i
    end

    if @max_wrong_guesses > 25
      @max_wrong_guesses = 25
      puts "\nErrr... well it's not really possible to guess wrong"
      puts "more than 25 times, so we'll just say 25 then. \n\n"
    end
  end

  def game_over
    @wrong_guesses_count -= 1
    render_board
    puts "#{@winner} wins!"
    #print "Play again? (y/n) "
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
    system("clear")
    puts "\n"
    puts "#{@board}#{" "*(19-@board.length)}Guess #{@wrong_guesses_count+1}/#{@max_wrong_guesses}"
    puts "#{"1234567890123456789".split("").take(@board.length).join("")}"
    puts "[#{@wrong_letters_guessed}]"
    puts ""
  end

  def instructions
    print "\nIf it occurs at more than one position, separate them with commas."
    print "\nExamples:\n\n    > 2\n    > 1,4,11\n"
    print "\nJust press Return if the letter doesn't occur. And please don't lie! "
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
    print "And what is the length of your secret word, #{@name}? "
    @secret_word = "_"*(gets.chomp.to_i)
    until @secret_word.length.between?(1,18)
      print "Please choose a length between 1 and 18 letters: "
      @secret_word = "_"*(gets.chomp.to_i)
    end
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
    print "\nAt which positions in your secret word does this letter occur? "

    unless @flag_instructions_given
      @game.instructions
      @flag_instructions_given = true
    end

    input_attempt = []
    1.times do
      input_attempt = gets.chomp.split(",").map(&:to_i)
      if input_attempt.empty?
        @game.wrong_guesses_count += 1
        @game.wrong_letters_guessed[guess.ord - 'a'.ord] = guess
      elsif input_attempt.all? { |input| input.between?(1,@game.board.length) }
        input_attempt.each { |index| @game.board[index-1] = guess }
      else
        print "Something's not right with your input. Please try again: "
        redo
      end
    end

    return input_attempt
  end

  def learn_from_guess(guess)
  end

end

class ComputerPlayer
  attr_accessor :dictionary, :secret_word, :game, :name, :possible_secret_words

  def initialize(name)
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @secret_word = nil
    @game = nil
    @name = name
    @possible_secret_words = []
    @possible_secret_words_setup_flag = false
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    puts "#{@secret_word}"
    puts "#{@name} has chosen the secret word. (Return to continue)"
    @game.board = "_"*@secret_word.length
    gets
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
    #no need for the computer to return positions
  end

  def learn_from_guess(guess, positions)
    if positions == []
      puts "ok, no positions?"
      @possible_secret_words = @possible_secret_words.reject do |possible_secret_word|
        possible_secret_word.include?(guess)
      end
    else
      puts "ok POSITIONS!"
      @possible_secret_words = @possible_secret_words.reject do |possible_secret_word|
        filter_this_word?(possible_secret_word, guess, positions)
      end
    end
    puts @possible_secret_words
    puts "POSSIBLE SECRET WORDS COUNT: #{@possible_secret_words.count}"
  end

  def filter_this_word?(possible_secret_word, guess, positions)
    puts "went into filter_this_word at all"
    filter = false
    possible_secret_word.split("").each_with_index do |ltr, i|

      if positions.include?(i+1) && ltr != guess
        filter = true
        puts "rejected b/c guess letter isn't in at least one of the spots you say it is:        #{possible_secret_word}"
        #this is one of the letters that was just guessed correctly
        #true in order to reject if in any of the passed positions it's not the guess
      elsif !positions.include?(i+1) && ltr == guess
        filter = true
        puts "rejected b/c guess letter *IS* in this word in a spot where you didn't say it was: #{possible_secret_word}"
        #you guessed the letter, it was in the word, but not in this position
        #so filter out all the words with the letter, but in this position
      end

    end
    puts "filter is #{filter}"
    filter
  end

  def guess
    # attempt = ('a'..'z').to_a.sample
    # until !@game.board.include?(attempt) && \
    #   !@game.wrong_letters_guessed.include?(attempt)
    #   attempt = ('a'..'z').to_a.sample
    # end

    if @possible_secret_words_setup_flag == false
      @possible_secret_words = @dictionary.select { |word| word.length == game.board.length}
      @possible_secret_words_setup_flag = true
    end

    # ltr_hash = Hash.new(0)
    # @game.board.split("").each_with_index do |unknown_ltr, i|
    #   next if unknown_ltr != "_"
    #   @possible_secret_words.each do |possible_secret_word|
    #     ltr_hash[possible_secret_word[i]] += 1
    #   end
    # end
    #
    # p ltr_hash.sort_by { |key, val| val }.reverse.reject { |h, k| @game.board.include?(h) || @game.wrong_letters_guessed.include?(h)}
    #
    # attempt = nil
    # until !attempt.nil? && !@game.board.include?(attempt) && \
    #   !@game.wrong_letters_guessed.include?(attempt)
    #   attempt = ltr_hash.max_by {|ltr,cnt| cnt}[0]
    #   ltr_hash.delete(ltr_hash.max_by {|ltr,cnt| cnt}[0])
    #   #puts "HIHIHIH"
    # end

    ltr_hash = Hash.new(0)
    @possible_secret_words.each do |word|
      @game.board.split("").each_with_index do |letter, index|
        ltr_hash[word[index]] += 1 if letter == "_"
      end
    end

    most_frequent_letters = ltr_hash.sort_by { |h, k| k }

    #attempt = ltr_hash.max_by {|ltr,cnt| cnt}[0]
    attempt, k = most_frequent_letters.last

    puts "#{@name} guesses '#{attempt}'."
    attempt
  end

end

if __FILE__ == $PROGRAM_NAME
  #load 'hangman_git.rb'
  hal = ComputerPlayer.new("HAL 9000")
  doug = HumanPlayer.new("Doug")
  #game = Hangman.new(doug,hal,5)  # human guesses
  game = Hangman.new(hal,doug,5) # computer guesses
  game.play
end

#i could have a play again loop

#i could have a reveal at the end (or option to reveal for the computer)

#i could have the AI play really cheaply

#i could add the ability to quit by typing quit at any time

#i could keep track of number of wins per player
