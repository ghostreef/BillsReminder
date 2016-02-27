class Parser < ActiveRecord::Base
  validates :name, length: { minimum: 1 }

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

  # only one parser can be enabled at a time
  def self.enable(parser)
    # disable all parses
    Parser.where(status: Parser.statuses[:enabled]).update_all(status: Parser.statuses[:disabled])

    parser.update(status: Parser.statuses[:enabled])
  end
end
