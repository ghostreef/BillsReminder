# rails g model Category name:string
class Category < ActiveRecord::Base
  validates :name, uniqueness: true, length: { minimum: 1 }

  # checked deleting a category with sources and purposes will delete corresponding rows in the mapping tables
  has_and_belongs_to_many :sources, after_add: :flush_cache, after_remove: :flush_cache
  has_and_belongs_to_many :purposes, after_add: :flush_cache, after_remove: :flush_cache

  belongs_to :category_set

  before_create :set_default_values

  def transactions
    s_ids = sources.pluck(:id)
    p_ids = purposes.pluck(:id)

    Transaction.where{(source_id.in s_ids) | (purpose_id.in p_ids)}
  end

  def to_graph_points
    transactions.select('abs(sum(amount)) as total, year(date) as year, month(date) as month').group('year, month')
  end

  def total
    transactions.sum(:amount)
  end

  # using rails cache to cache total, note the association callbacks, compare and contrast this with source total
  # any time a source or purpose is added or removed from a category, the cache must be cleared
  # any time a transaction that is associated to this category is changed, the cache must be cleared
  def cached_total
    Rails.cache.fetch([self, 'total']) { transactions.sum(:amount) }
  end

  private

  # association callbacks must have a param
  def flush_cache(useless_self)
    touch if persisted?
  end

  # by default all categories should be graph able
  def set_default_values
    self.graph ||= '1'
  end
end
