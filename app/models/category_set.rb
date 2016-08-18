class CategorySet < ActiveRecord::Base
  validates :name, presence: true
  has_many :categories

  def inclusive?
    inclusive
  end
end
