# rails g model Transaction date:date amount:decimal raw_description:string description:string source:references purpose:references
class Transaction < ActiveRecord::Base
  @date_format = '%m/%d/%Y'

  belongs_to :source
  belongs_to :purpose
  has_many :categories, through: :source

  validates :date, :raw_description, presence: true
  validates :amount, numericality: true

  after_save :sync_source, if: :source_changed? # this will sync source when changed (for performance)
  after_save :touch_category, if: :amount_changed? # this will flush the categories cache

  alias_attribute :transaction_id, :id  # this alias is for sunspot, 'id' is reserved in sunspot

  searchable do
    text :transaction do
      "#{raw_description} #{amount} #{transaction_id}"
    end
  end

  def self.changeable
    # returns changeable column names
    Transaction.column_names.keep_if { |x| x.scan(/_at\z|_id\z|\Araw_|\Aid\z/).empty? }
  end

  def self.derivable
    # an attribute is either given or derived
    # given attributes are (date, amount, raw_description), everything else is derived
    Transaction.changeable - %w(raw_description date amount)
  end

  def self.date_format
    @date_format
  end

  def self.date_format=(date)
    @date_format = date
  end

  # instead of overriding the setters for date and amount, I decided to add helper methods to do formatting because I
  # don't want it to be magical
  def self.format_date(date)
    Date.strptime(date, Transaction.date_format) rescue 'invalid date'
  end

  def self.format_amount(amount)
    amount.to_s.delete('$').to_f.round(2)
  end

  def absolute_amount
    amount.abs
  end

  private

  def source_changed?
    changed.include?('source_id')
  end

  def amount_changed?
    changed.include?('amount')
  end

  def sync_source
    (Source.find(source_id_was).decrement(:popularity).decrement(:total, amount).save) if source_id_was.present?
    (Source.find(source_id).increment(:popularity).increment(:total, amount).save) if source_id.present?
  end

  def touch_category
    categories.map(&:touch)
  end
end
