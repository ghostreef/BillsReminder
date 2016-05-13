# rails g model Transaction date:date amount:decimal raw_description:string description:string source:references purpose:references
class Transaction < ActiveRecord::Base
  belongs_to :source
  belongs_to :purpose

  has_many :categories, through: :source

  validates :date, :raw_description, presence: true
  validates :amount, numericality: true

  DEFAULT_DATE_FORMAT = '%m/%d/%Y'

  after_create :parse

  after_save :sync_source, if: :source_changed?

  after_save :touch_category, if: :amount_changed?

  scope :unknown, -> { where(source: nil) }

  # we have to create an alias because sunspot uses 'id'
  alias_attribute :transaction_id, :id
  
  searchable do
    text :transaction do
      "#{raw_description} #{amount} #{transaction_id}"
    end
  end

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
    amount.to_s.delete('$').to_f.round(2)
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

  # ATM parse sets source, purpose, and description using the raw_description
  def parse
    description = split_description(strip_description)

    source = nil
    description.each do |chunk|
      source = guess_source(chunk)
      break if source.present?
    end
    
    # how do I join with regex
    update(description: description.join('  '), source: source, purpose: source.try(:default_purpose))
  end

  def absolute_amount
    amount.abs
  end

  def sync_source
    (Source.find(source_id_was).decrement(:popularity).decrement(:total, amount).save) if source_id_was.present?
    (Source.find(source_id).increment(:popularity).increment(:total, amount).save) if source_id.present?
  end

  def source_changed?
    changed.include?('source_id')
  end

  def touch_category
    categories.map(&:touch)
  end

  def amount_changed?
    changed.include?('amount')
  end

end
