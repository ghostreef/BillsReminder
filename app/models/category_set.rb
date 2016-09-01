class CategorySet < ActiveRecord::Base
  validates :name, presence: true
  has_many :categories

  # does this set include all transactions?
  def inclusive?
    false
  end

  def total
    # call flatten so we can use enumerable::sum, total is a virtual attribute
    categories.flatten.sum(&:total)
  end
end
