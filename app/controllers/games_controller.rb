require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { (65 + rand(26)).chr }
  end

  def score
    word_result = params["word"].upcase
    letters = params["letters"]

    @answer = if invalid_use_of_letters?(word_result, letters)
                "word can't be created with the grid"
              elsif !valid_english_word(word_result)
                "word can be created with the grid, but it's not a valid English word"
              else
                "Congratulation! #{word_result} is a valid English word!"
              end
  end

  private

  def invalid_use_of_letters?(word_result, letters)
    word_result.split('').uniq.any? do |letter|
      word_result.count(letter) > letters.count(letter)
    end
  end

  def valid_english_word?(word_result)
    url = "https://wagon-dictionary.herokuapp.com/#{word_result}"
    response = URI.open(url).read
    data = JSON.parse(response)

    data["found"]
  end
end
