class Parser < ActiveRecord::Base
  validates :name, length: { minimum: 1 }

  enum status: {
           enabled: 0,
           disabled: 1,
           incomplete: 2
       }
end
