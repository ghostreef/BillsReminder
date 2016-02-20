class Source < ActiveRecord::Base
  validates :name, :regex, length: { minimum: 1 }
  validates :name, uniqueness: true

  has_and_belongs_to_many :categories

  # in my head this is backwards, but the fk goes in this table
  belongs_to :purpose
  # also note if a purpose is deleted, purpose_id remains, but .purpose will return nil

  def total

  end

  def custom_error_messages
    errors.map do |attribute, error|
      "#{attribute} '#{send(attribute)}' #{error}."
    end
  end
end
