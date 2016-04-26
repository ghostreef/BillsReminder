class Source < ActiveRecord::Base
  validates :name, :regex, length: { minimum: 1 }
  validates :name, uniqueness: true
  validates :total, :popularity, numericality: { greater_than_or_equal_to: 0 }
  validates :popularity, numericality: { only_integer: true }

  has_and_belongs_to_many :categories
  has_many :transactions

  # this must be done first or you get a mysql error
  before_destroy :clean_join_table

  # in my head this is backwards, but the fk goes in this table
  belongs_to :purpose
  # also note if a purpose is deleted, purpose_id remains, but .purpose will return nil
  # TODO I think I fixed this ^ check later

  alias_attribute :default_purpose, :purpose

  before_validation :set_default_values
  
  scope :not_categorized, -> { where('id not in (select source_id from categories_sources)') }

  def custom_error_messages
    errors.map do |attribute, error|
      "#{attribute} '#{send(attribute)}' #{error}."
    end
  end

  def to_d3_json
    { name: name, value: total.to_f }
  end

  private

  def set_default_values
    self.popularity = 0
    self.total = 0.0
  end

  def clean_join_table
    # source_id is also in bills, categories
    self.transactions = []
  end
end
