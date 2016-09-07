# rails g model Purpose name:string
class Purpose < ActiveRecord::Base
  validates :name, uniqueness: true, length: { minimum: 1 }

  SUGGESTED_DEFAULTS = ['external transfer', 'internal transfer', 'income', 'services rendered', 'goods rendered',
                        'credit card payment', 'loan payment', 'anonymous', 'miscellaneous']

  before_destroy :clean_join_table # this must be done first or you get a mysql error
  before_save :set_default, if: :default_changed?

  has_many :sources
  has_many :bills
  has_many :transactions
  has_and_belongs_to_many :categories

  def self.default_purpose
    Purpose.where(default: true).first
  end

  def custom_error_messages
    errors.map do |attribute, error|
      "#{attribute} '#{send(attribute)}' #{error}."
    end
  end

  private

  def default_changed?
    changed.include?('default')
  end

  def set_default
    Purpose.update_all(default: false)
  end

  def clean_join_table
    self.sources = self.categories = self.bills self.transactions = []
  end
end
