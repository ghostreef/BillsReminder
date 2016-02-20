class CategoriesController < ApplicationController

  def index
    # .all?
    @categories = Category.all.order(:name)
  end

end
