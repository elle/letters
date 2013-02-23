#! /usr/bin/env ruby

require 'minitest/autorun'
require 'minitest/spec'

class Letters

  attr_accessor :letters, :words

  def initialize(letters, words=File.read('dict.txt').lines.map(&:strip))
    @letters = letters
    @words = words
  end

  def find_longest
    # output of gorup_by: {3=>["bat"], 4=>["bath"]}
    # output of max: [4, ["bath"]]
    # output of last: ["bath"]
    matches.group_by(&:size).max.last[0] if matches.any?
  end

  def matches
    words.select { |word| word if include?(word) }
  end

  def itersection(word)
    word_array(word) & letters_array
  end

  def include?(word)
    # (word_array(word) - letters).empty? # this does not handle duplicate letters
    itersection(word).length == word_array(word).length
  end

  def word_array(word)
    word.downcase.chars.to_a
  end

  def letters_array
    letters.downcase.chars.to_a
  end
end

# TODO: too slow, since it iterates through all the words
#p Letters.new('abcdefghijklmnopqrstuvyxyz').find_longest # => 'dermatoglyphics'

describe Letters do
  before do
    @words = %w.cat bat bath baths baht.
    @result = Letters.new('abhtg', @words).find_longest
  end

  it 'finds bath' do
    assert_equal 'bath', @result
  end

  it 'handles uppercase' do
    result = Letters.new('ABGHT', @words).find_longest
    assert_equal 'bath', @result
  end

  %w.cat bat baths..each do |word|
    it "does not find #{word}" do
      refute_equal word, @result
    end
  end

  it 'does not find words with duplicate letters' do
    words = %w.formaldehydesulphoxylate dad.
    result = Letters.new('abcdefghijklmnopqrstuvyxyz', words).find_longest
    refute_equal 'formaldehydesulphoxylate', result
    assert_nil result
  end
end
