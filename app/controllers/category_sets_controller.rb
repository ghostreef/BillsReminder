class CategorySetsController < ApplicationController

  before_action :find_set, only: [:show, :edit, :update, :destroy, :graph]

  def index
    @sets = CategorySet.order(:name)
  end

  def show

  end

  def new
    @set = CategorySet.new
  end

  def edit

  end

  def create
    @set = CategorySet.new(category_set_params)

    @set.save ? redirect_to(@set) : render(:new)
  end

  def update
    @set.update(category_set_params) ? redirect_to(@set) : render(:edit)
  end

  def destroy
    if @set.destroy
      redirect_to category_sets_path, notice: 'Set successfully destroyed.'
    else
      redirect_to category_sets_path, flash: {error: 'Failed to destroy set.'}
    end
  end

  def graph
    points = @set.categories.map { |category| { key: category.name, y: category.total.to_f } }
    @pies = [title: @set.name, points: points]
  end

  def seed
    file = File.read('data/sets.json')
    data = JSON.parse(file)

    categories = Category.pluck(:name, :id).to_h

    data.each do |datum|
      category_ids = categories.values_at(*datum['categories'])
      CategorySet.create(category_set_hash(datum).merge(category_ids: category_ids))
    end
  end

  private

  def find_set
    begin
      @set = CategorySet.find(params[:id].to_i)
    rescue
      # what
    end
  end

  def category_set_params
    category_set_hash.require(:category_set)
  end

  def category_set_hash(hash)
    hash.permit(:name, category_ids: [])
  end
end
