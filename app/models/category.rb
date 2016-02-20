# rails g model Category name:string
class Category < ActiveRecord::Base
  validates :name, uniqueness: true, length: { minimum: 1 }

  def transactions

  end

  def total

  end
end
