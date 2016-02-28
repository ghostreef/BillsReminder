# rails g model Transaction date:date amount:decimal raw_description:string description:string source:references purpose:references
class Transaction < ActiveRecord::Base
  belongs_to :source
  belongs_to :purpose

  validates :date, :raw_description, presence: true
  validates :amount, numericality: { greater_than: 0 }

  def guess_source
    guess = nil

    Source.all.each do |source|
      regexp = Regexp.new(source.regex)
      if regexp.match(raw_description)
        guess = source
        break
      end
    end

    guess
  end

  def guess_purpose
    guess_source.nil? ? nil : guess_source.default_purpose
  end

  def generate_description

  end
end
