# rails g model Transformation pattern:string transform:string value:string
class Transformation < ActiveRecord::Base
  # not that uniqueness true could stop patterns from matching the same string
  validates :pattern, uniqueness: true, length: { minimum: 1 }

  before_create :set_default_values

  private

  def set_default_values
    self.transform ||= ''
  end
end
