# rails g model Category name:string
class Category < ActiveRecord::Base
  validates :name, uniqueness: true, length: { minimum: 1 }

  # checked deleting a category with sources and purposes will delete corresponding rows in the mapping tables
  has_and_belongs_to_many :sources
  has_and_belongs_to_many :purposes

  def transactions
    s_ids = sources.pluck(:id)
    p_ids = purposes.pluck(:id)

    Transaction.where{(source_id.in s_ids) | (purpose_id.in p_ids)}
  end

  def d3_graph_points
    transactions.select('sum(amount) as total, year(date) as year, month(date) as month').group('year, month')
  end

  def total
    # thinking of caching this value
  end
end
