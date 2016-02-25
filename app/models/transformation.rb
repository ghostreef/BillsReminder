# rails g model Transformation pattern:string transform:string value:string
class Transformation < ActiveRecord::Base
  # not that uniqueness true could stop patterns from matching the same string
  validates :pattern, uniqueness: true, length: { minimum: 1 }

  before_create :set_default_values

  # these give us Transformation.date, Transformation.split...
  enum transformation_type: {
     date: 0,
     split: 1,
     transform: 2,
     strip: 3
  }

  has_and_belongs_to_many :parsers

  def custom_error_messages

  end

  private

  def set_default_values
    self.transform ||= ''
  end
end
