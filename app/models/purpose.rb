# rails g model Purpose name:string
class Purpose < ActiveRecord::Base
  validates :name, uniqueness: true, length: { minimum: 1 }

  has_many :sources

  def custom_error_messages
    errors.map do |attribute, error|
      "'#{send(attribute)}' #{error}."
    end
  end
end
