# rails g model Purpose name:string
class Purpose < ActiveRecord::Base
  validates :name, uniqueness: true, length: { minimum: 1 }

  has_many :sources
  has_and_belongs_to_many :categories

  def custom_error_messages
    errors.map do |attribute, error|
      "#{attribute} '#{send(attribute)}' #{error}."
    end
  end
end
