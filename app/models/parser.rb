class Parser < ActiveRecord::Base
  validates :name, length: { minimum: 1 }

  before_create :set_default_values
  before_update :update_status

  enum status: {
           enabled: 0,
           disabled: 1,
           incomplete: 2
       }

  has_and_belongs_to_many :transformations

  def date_transformations
    transformations.where(transformation_type: 0)
  end

  def split_transformations
    transformations.where(transformation_type: 1)
  end

  def other_transformations
    transformations.where(transformation_type: [2, 3])
  end

  def date_transformation
    date_transformations.try(:first) || nil
  end

  def split_transformation
    split_transformations.try(:first) || nil
  end

  # only one parser can be enabled at a time
  def self.enable(parser)
    # disable all parses
    Parser.where(status: Parser.statuses[:enabled]).update_all(status: Parser.statuses[:disabled])

    parser.update(status: Parser.statuses[:enabled])
  end

  def incomplete?
    date_transformations.count == 0 || split_transformations.count == 0
  end

  private

  def set_default_values
    (self.status ||= Parser.statuses[:incomplete]) if self.incomplete?
    self.status ||= Parser.statuses[:disabled]
  end

  def update_status
    self.status = self.incomplete? ? Parser.statuses[:incomplete] : Parser.statuses[:disabled]
  end
end
