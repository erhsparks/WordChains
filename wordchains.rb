require "set"

class WordChainer
  attr_reader :dictionary, :current_words, :all_seen_words

  def initialize(dictionary="dictionary.txt")
    @dictionary = File.readlines(dictionary).map { |line| line.strip }
    @dictionary = @dictionary.to_set
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source => nil }

    explore_current_words until @current_words.empty? ||
                                    @all_seen_words.key?(target)
    path = build_path(target)

    puts path.reverse
  end

  def build_path(target)
    return [target] if @all_seen_words[target].nil?

    last_word = @all_seen_words[target]
    path = [target]

    path.concat(build_path(last_word))
  end

  def explore_current_words
    new_current_words = []

    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        unless @all_seen_words.include?(adjacent_word)
          new_current_words << adjacent_word
          @all_seen_words[adjacent_word] = current_word
        end
      end
    end

#    new_current_words.each do |word|
#      puts "#{word} came from #{@all_seen_words[word]}"
#    end
    @current_words = new_current_words
  end

  def adjacent_words(word)
    sub_dictionary = @dictionary.select do |entry|
       entry.length == word.length && compare(word, entry)
    end
  end

  def compare(word1, word2)
    letters1 = word1.chars
    letters2 = word2.chars

    count = 0
    letters1.each_with_index do |letter, idx|
      count += 1 unless letter == letters2[idx]
    end

    count <= 1
  end


end
