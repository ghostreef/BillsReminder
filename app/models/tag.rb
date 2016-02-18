class Tag < ActiveRecord::Base
  validates :name, :regex, presence: true, length: { minimum: 1 }
  validates :name, uniqueness: true
end
