class Tag < ActiveRecord::Base
  validates :name, :regex, presence: true
  validates :name, uniqueness: true
end
