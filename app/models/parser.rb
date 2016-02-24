class Parser < ActiveRecord::Base
  validates :name, length: { minimum: 1 }

  enum status: {
           enabled: 0,
           disabled: 1,
           incomplete: 2
       }

  has_and_belongs_to_many :transformations
end
