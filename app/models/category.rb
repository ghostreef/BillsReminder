# rails g model Category name:string
class Category < ActiveRecord::Base
  validates :name, uniqueness: true, length: { minimum: 1 }

  has_and_belongs_to_many :sources
  has_and_belongs_to_many :purposes

  def transactions

  end

  def total

  end
end
