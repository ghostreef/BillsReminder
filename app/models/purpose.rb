# rails g model Purpose name:string
class Purpose < ActiveRecord::Base
  validates :name, uniqueness: true
end
