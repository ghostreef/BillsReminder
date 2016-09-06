class CategorySet < ActiveRecord::Base
  validates :name, presence: true
  has_many :categories

  has_many :sources, through: :categories
  has_many :purposes, through: :categories

  # does this set include all transactions?
  def complete?
    false
  end

  def total
    # call flatten so we can use enumerable::sum, total is a virtual attribute
    categories.flatten.sum(&:total)
  end

  def missing
    source_ids = sources.pluck(:id)
    purpose_ids = purposes.pluck(:id)
    # if a set is a collection of sources and purposes (through categories), any transaction without that source AND purpose
    # is not included in this set
    Transaction.where.not(source_id: source_ids, purpose_id: purpose_ids)
  end

  def overlap
    # this is kinda brute force
    transaction_ids = categories.map { |category| category.transactions.pluck(:id) }.flatten.group_by{ |e| e }.select { |k, v| v.size > 1 }.keys
    Transaction.find(transaction_ids)
  end
end
