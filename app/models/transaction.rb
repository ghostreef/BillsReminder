# rails g model Transaction date:date amount:decimal raw_description:string description:string source:references purpose:references
class Transaction < ActiveRecord::Base
  belongs_to :source
  belongs_to :purpose

  validates :date, :raw_description, presence: true
  validates :amount, numericality: { greater_than: 0 }

  # I don't want guess methods to set anything for me.
  def guess_source
    Source.all.each do |source|
      if raw_description =~ /#{source.regex}/i
        @source = source
        break
      end
    end

    @source
  end

  # Feels wrong that guess_purpose relies on guess_source, but purpose comes from source.
  def guess_purpose
    # use most recent source guess, if none available make the guess, the guess may still be nil
    (@source || source || guess_source).try(default_purpose)
  end

  def generate_description

  end
end
