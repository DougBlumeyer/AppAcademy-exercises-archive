#require 'byebug'
require 'set'

class WordChainer
  def initialize(dictionary_file_name)
    @dictionary = Set.new
    File.readlines(dictionary_file_name).each do |line|
      @dictionary.add(line.chomp)
    end
  end

  def adjacent_words(word)
    adj_words = []
    word.split("").each_with_index do |letter, index|
      ('a'..'z').each do |replacement|
        next if letter == replacement
        test_word = word.dup
        test_word[index] = replacement

        if @dictionary.include?(test_word)
          adj_words << test_word #unless adj_words.include?(test_word)
        end
      end
    end
    adj_words
  end

  def run(target,source)
    @current_words = [source]
    @all_seen_words = { source => nil }

    until @current_words.empty?
      @current_words = explore_current_words
      break if @all_seen_words.include?(target)
    end

    build_path(target)
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        next if @all_seen_words.include?(adjacent_word)
        new_current_words << adjacent_word
        @all_seen_words[adjacent_word] = current_word
      end
    end

    #new_current_words.each do |new_current_word|
    #  puts "#{new_current_word} => #{@all_seen_words[new_current_word]}"
    #end

    new_current_words
  end

  def build_path(target)
    if target == nil
      path = []
    else
      path = build_path(@all_seen_words[target]) << target
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  # provide file name on command line
  p WordChainer.new("dictionary.txt").run(ARGV.pop, ARGV.pop)
end
