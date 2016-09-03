class CategorySet < ActiveRecord::Base
  validates :name, presence: true
  has_many :categories

  has_many :sources, through: :categories
  has_many :purposes, through: :categories

  # does this set include all transactions?
  def inclusive?
    false
  end

  def total
    # call flatten so we can use enumerable::sum, total is a virtual attribute
    categories.flatten.sum(&:total)
  end

  def missing
    source_ids = sources.pluck(:id)
    purpose_ids = purposes.pluck(:id)
    Transaction.where.not(source_id: source_ids, purpose_id: purpose_ids)
  end


  def overlap
    return [] if sources.empty? || purposes.empty?

    # a set is really a collection of sources and purposes (through categories)
    # if there are repeats or if source implies a purpose or a purpose implies a source
    # then somewhere a transaction is being counted more than once
    source_names = sources.pluck(:name) + purposes.map {|p| p.source.name}
    purpose_names = purposes.pluck(:name) + sources.map {|s| s.purpose.name}

    duplicate_sources = source_names - Set.new(source_names)
    duplicate_purposes = purpose_names - Set.new(purpose_names)
    
    duplicate_sources + duplicate_purposes
  end
end
