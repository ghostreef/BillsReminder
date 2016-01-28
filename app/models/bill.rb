class Bill < ActiveRecord::Base
  validates :issuer, :bill_type, :amount, :term_unit, :term_number, :due_date, presence: true
  validates :amount, :term_number, numericality: { greater_than: 0 }
  validates :term_number, numericality: { only_integer: true }

  validate :date_cannot_be_in_the_past, on: :create

  before_create :set_default_values

  enum term_unit: { daily: 0, weekly: 1, monthly: 2, yearly: 3 }

  def date_cannot_be_in_the_past
    if due_date.present? && due_date < Date.today
      errors.add(:due_date, "can't be in the past")
    end
  end

  def auto_pay?
    self.auto_pay ? 'yes' : 'no'
  end

  def status
    if self.paid
      'paid'
    elsif Date.today > self.due_date
      'late'
    elsif (Date.today + 7.days) >= self.due_date
      'soon'
    else
      'later'
    end
  end

  private

  def set_default_values
    # gotcha, boolean values are set to 0 and 1, not true and false
    self.paid ||= '0'
    self.auto_pay ||= '0'
  end
end
