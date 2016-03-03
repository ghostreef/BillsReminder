# rails g model Transaction date:date amount:decimal raw_description:string description:string source:references purpose:references
class Transaction < ActiveRecord::Base
  belongs_to :source
  belongs_to :purpose

  validates :date, :raw_description, presence: true
  validates :amount, numericality: { greater_than: 0 }

  # I don't want guess methods to set anything for me.
  def guess_source
    Source.all.each do |source|
      if raw_description =~ /#{source.regex}/i
        @source = source
        break
      end
    end

    @source
  end

  # Feels wrong that guess_purpose relies on guess_source, but purpose comes from source.
  def guess_purpose
    # use most recent source guess, if none available make the guess, the guess may still be nil
    (@source || source || guess_source).try(default_purpose)
  end

  def generate_description

  end

  # faster than the first try, but could still be better
  def self.find_pattern_in_words(patterns, words, case_insensitive)

    words.each_with_index do |word, index|

      which_pattern = patterns.each_with_index do |pattern, index|
        break index if word =~ /\A#{pattern}\z/
        break index if case_insensitive && word =~ /\A#{pattern}\z/i
      end

      # this will be immediate if which_pattern is a number
      break which_pattern, index if which_pattern.is_a?(Fixnum)
      break [nil, nil] if index == (words.length - 1) && which_pattern.is_a?(Array)
    end

  end

end
