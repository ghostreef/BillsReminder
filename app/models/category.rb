# rails g model Category name:string
class Category < ActiveRecord::Base
  validates :name, uniqueness: true, length: { minimum: 1 }

  has_and_belongs_to_many :sources
  has_and_belongs_to_many :purposes

  def transactions
    s_ids = sources.pluck(:id)
    p_ids = purposes.pluck(:id)

    Transaction.where{(source_id.in s_ids) | (purpose_id.in p_ids)}
  end

  def total

  end
end
