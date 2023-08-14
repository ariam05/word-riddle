class WordGuesserGame
  attr_reader :word, :guesses, :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = ''
  end

  def guess(letter)
    letter = letter.to_s.strip
    
    #not valid guess 
    raise ArgumentError, 'Invalid guess: must be single letter' unless letter.match?(/[[:alpha:]]/)
    raise ArgumentError, 'Guess cannot be empty' if letter.empty?
    
    letter = letter.downcase
    if ((@guesses + @wrong_guesses).include?(letter))
      return false
    end 
    if @word.include?(letter)
      @guesses << letter 
    else
      @wrong_guesses << letter 
    end 
  
    #valid guess, return true 
    true
  end
  def word_with_guesses
    out = ''
    @word.chars do |char|
      if @guesses.include?(char)
        out << char
      else 
        out << '-'
      end 
    end 
    out 
  end 

  def check_win_or_lose
    return :win if !(word_with_guesses.include?('-'))
    return :lose if @wrong_guesses.length >= 7
    :play
  end 

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
 