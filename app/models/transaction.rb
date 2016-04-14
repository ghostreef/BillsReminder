# rails g model Transaction date:date amount:decimal raw_description:string description:string source:references purpose:references
class Transaction < ActiveRecord::Base
  belongs_to :source
  belongs_to :purpose

  validates :date, :raw_description, presence: true
  validates :amount, numericality: { greater_than: 0 }

  DEFAULT_DATE_FORMAT = '%m/%d/%Y'

  after_create :parse

  scope :unknown, -> { where(source: nil) }

  # returns the column names a user is allowed to change
  def self.changeable
    Transaction.column_names.keep_if { |x| x.scan(/_at\z|_id\z|\Araw_|\Aid\z/).empty? }
  end

  # returns the attributes that are derived from the 3 main required attributes
  #  date, description, and amount are required for a complete transaction object, maybe not useful
  def self.derivable
    Transaction.changeable - %w(raw_description date amount)
  end

  # gets the date format
  def self.date_format
    parser = Parser.parser

    # how bad is this coupling?
    parser.present? && parser.date_transformation.present? ? parser.date_transformation.regex : DEFAULT_DATE_FORMAT
  end

  def self.format_date(date)
    Date.strptime(date, Transaction.date_format) rescue 'invalid date'
  end

  def self.format_amount(amount)
    amount.to_s.delete('-$').to_f.abs.round(2)
  end

  def guess_source(description=raw_description)
    result = nil
    Source.order(popularity: :desc).each do |source|
      if description =~ /#{source.regex}/i
        result = source
        break
      end
    end

    result
  end

  # Feels wrong that guess_purpose relies on guess_source, but purpose comes from source.
  def guess_purpose
    # use most recent source guess, if none available make the guess, the guess may still be nil
    (source || guess_source).try(:default_purpose)
  end


  def split_description(description=raw_description)
    regexp = Regexp.new(Parser.parser.split_transformation.regex)
    description.split(regexp).map(&:strip).delete_if(&:empty?)
  end

  def strip_description(description=raw_description)
    # x['Purchase'] = '', regex and string, errors on no match
    # x.slice!('Card'), regex and string, returns removed match
    # x.gsub('Card', ''), regex and string
    # x.sub('Card', ''), regex and string
    # x.delete('Card'), only string
    # x =~ /Card/, this matches
    # as you can see there are so many ways to do this

    regex = Parser.parser.strip_transformations.pluck(:regex).map { |r| "(#{r})" }.join('|')
    # gsub is required to remove multiples
    description.gsub(/#{regex}/, '')
  end


  # ok what am I doing
  def parse

    # remove first
    if source.present?
      source.decrement(:popularity)
      source.total -= amount
      source.save
    end

    description = split_description(strip_description)
    source = guess_source(description[0])

    unless source.nil?
      source.increment(:popularity)
      source.total += amount
      source.save
    end

    update(description: description.join('  '), source: source, purpose: source.try(:default_purpose))
  end
end
