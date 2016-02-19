class Source < ActiveRecord::Base
  validates :name, :regex, presence: true, length: { minimum: 1 }
  validates :name, uniqueness: true

  # in my head this is backwards, but the fk goes in this table
  belongs_to :purpose
  # also note if a purpose is deleted, purpose_id remains, but .purpose will return nil

  def total

  end

  def custom_error_messages
    errors.map do |attribute, error|
      "'#{send(attribute)}' #{error}."
    end
  end
end
