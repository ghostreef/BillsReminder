# rails g model Purpose name:string
class Purpose < ActiveRecord::Base
  validates :name, uniqueness: true, length: { minimum: 1 }

  SUGGESTED_DEFAULTS = ['external transfer', 'internal transfer', 'income', 'services rendered', 'goods rendered',
                        'credit card payment', 'loan payment', 'anonymous', 'miscellaneous']

  # this must be done first or you get a mysql error
  before_destroy :clean_join_table

  has_many :sources
  has_many :bills
  has_many :transactions
  has_and_belongs_to_many :categories

  def custom_error_messages
    errors.map do |attribute, error|
      "#{attribute} '#{send(attribute)}' #{error}."
    end
  end

  private

  def clean_join_table
    self.sources = self.categories = self.bills self.transactions = []
  end
end
