module ApplicationHelper
  def display_price(price)
    price == 0.0 ? '-' : number_to_currency(price)
  end
end
