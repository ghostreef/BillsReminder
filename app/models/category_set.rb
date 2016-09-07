class CategorySet < ActiveRecord::Base
  validates :name, presence: true
  has_many :categories

  has_many :sources, through: :categories
  has_many :purposes, through: :categories

  before_destroy :clear_associations

  # does this set include all transactions?
  def complete?
    total == Transaction.grand_total
  end

  def total
    # call flatten so we can use enumerable::sum, total is a virtual attribute
    categories.flatten.sum(&:cached_total)
  end

  def missing_transactions
    source_ids = sources.pluck(:id)
    purpose_ids = purposes.pluck(:id)
    # if a set is a collection of sources and purposes (through categories), any transaction without that source AND purpose
    # is not included in this set
    Transaction.where.not(source_id: source_ids, purpose_id: purpose_ids)
  end

  def overlapping_transactions
    # this is kinda brute force
    transaction_ids = categories.map { |category| category.transactions.pluck(:id) }.flatten.group_by{ |e| e }.select { |k, v| v.size > 1 }.keys
    Transaction.find(transaction_ids)
  end

  # shallow check
  def overlapping_sources
    sources = categories.map(&:sources).flatten.group_by{ |e| e }.select { |k, v| v.size > 1 }.keys
    sources.map { |source| [source.id, source.name] }.to_h
  end

  # shallow check
  def overlapping_purposes
    purposes = categories.map(&:purposes).flatten.group_by{ |e| e }.select { |k, v| v.size > 1 }.keys
    purposes.map { |purpose| [purpose.id, purpose.name] }.to_h
  end

  def missing_category
    Category.new(name: 'missing', transactions: missing_transactions)
  end

  def overlapping_category
    Category.new(name: 'overlapping', transactions: overlapping_transactions)
  end

  private

  # isn't there a way to do this in rails?
  def clear_associations
    self.categories = []
  end
end
