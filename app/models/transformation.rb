class Transformation < ActiveRecord::Base
  # regex, case_insensitive, derives, value, implies, set, complexity
  validates :regex, uniqueness: true, length: {minimum: 1}

  belongs_to :transformation
  alias_attribute :implies, :transformation

  before_create :set_default_values


  # these give us Transformation.date, Transformation.split...
  enum set: {
           date: 0,
           split: 1,
           transform: 2,
           strip: 3
       }

  enum complexity: {
           simple: 1,
           straightforward: 2,
           complex: 3
       }

  def custom_error_messages

  end

  private

  def set_default_values
    self.value ||= ''
    self.complexity = (self.regex =~ /\*\[\]\(\)\+\\\$\^\?\{\}\.\|/) ? 3 : 1
  end

end
