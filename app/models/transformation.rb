class Transformation < ActiveRecord::Base
  # regex, case_insensitive, derives, value, implies, set, complexity
  validates :regex, uniqueness: true, length: {minimum: 1}
  validate :implies_and_derives_cannot_be_the_same, :cannot_imply_self

  has_and_belongs_to_many :parsers
  belongs_to :transformation
  alias_attribute :implies, :transformation

  before_create :set_default_values

  before_save :evaluate_complexity, if: :regex_changed?

  after_destroy :clean_join_table

  before_destroy :update_parsers

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

  def implies_and_derives_cannot_be_the_same
    if implies.present? && derives.present? && implies != self && implies.derives == derives
      errors.add(:base, 'Transformation cannot imply and derive the same attribute')
    end
  end

  def cannot_imply_self
    if implies == self
      errors.add(:base, 'Transformation cannot imply self')
    end
  end

  def custom_error_messages
    errors.map do |attribute, error|
      if attribute == :base
        error
      else
      "#{attribute} '#{send(attribute)}' #{error}."
      end
    end
  end

  private

  # check both parent and child in linked list
  # meaning if I change derives then I have to check all transformations that imply this one
  def check_for_implication_loops
  #   actually this is tricky
  end

  def regex_changed?
    changed.include?('regex')
  end

  def set_default_values
    # value would be nil if there is no input in the form for it
    # have to use self in callbacks
    self.value ||= ''
  end

  def evaluate_complexity
    self.complexity = (self.regex =~ /%|\*|\[|\]|\(|\)|\+|\\|\$|\^|\?|\{|\}|\.|\|/) ? 3 : 1
    # Transformation.complexities[:complex]
    # Transformation.complexities[:simple]
  end

  # well this sucks, another drawback to habtm association
  def clean_join_table
    # these 2 lines run pretty much the same sql, self.parses adds a where in clause
    self.parsers = []
    # OR
    # ActiveRecord::Base.connection.execute("DELETE FROM parsers_transformations WHERE transformation_id = #{id}")
  end

  def update_parsers
    parsers.each do |parser|
      parser.transformations.delete(self)
      parser.save
    end
  end
end
