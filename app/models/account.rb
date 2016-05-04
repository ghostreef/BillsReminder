class Account < ActiveRecord::Base
  validates :name, :username, presence: true
end
