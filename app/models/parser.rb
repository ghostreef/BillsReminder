class Parser < ActiveRecord::Base
  validates :name, length: {minimum: 1}

  has_and_belongs_to_many :transformations

  before_save :set_status, unless: :status_changed?

  after_destroy :clean_join_table

  serialize :search_order, JSON
  serialize :expected_order, JSON

  enum status: {
           enabled: 0,
           disabled: 1,
           incomplete: 2
       }

  def self.parser
    Parser.find_by_status(Parser.statuses[:enabled])
  end

  def strip_transformations
    transformations.strip
  end

  def transform_transformations
    transformations.transform
  end

  def date_transformations
    transformations.date
  end

  def split_transformations
    transformations.split
  end

  def other_transformations
    # rails merge uses 'where and' clause, so I have to do this
    transformations.where(set: [Transformation.sets[:transform], Transformation.sets[:strip]])
  end

  def date_transformation
    date_transformations.try(:first) || nil
  end

  def split_transformation
    split_transformations.try(:first) || nil
  end

  def enable
    # disable all enabled parsers, only one parser can be enabled at a time
    Parser.enabled.update_all(status: Parser.statuses[:disabled])

    # mark this parser as enabled
    update(status: Parser.statuses[:enabled])
  end

  # checks transformations, runs queries
  def is_incomplete?
    date_transformations.count == 0 || split_transformations.count == 0 || other_transformations.count == 0
  end

  private

  def status_changed?
    changed.include?('status')
  end

  # make sure to use the active record collection proxy, the relation does not reflect current changes
  # also worth noting self is not needed with associations...kinda annoying
  def set_status
    # important: use map on collection, not relation!
    list = transformations.map(&:set)

    if list.include?('date') && list.include?('split') && list.include?('transform')
      self.status = Parser.statuses[:disabled]
    else
      self.status = Parser.statuses[:incomplete]
    end
  end

  # well this sucks, another drawback to habtm association
  def clean_join_table
    # these 2 lines run pretty much the same sql, self.transformations adds a where in clause
    self.transformations = []
    # OR
    # ActiveRecord::Base.connection.execute("DELETE FROM parsers_transformations WHERE parser_id = #{id}")
  end
end
