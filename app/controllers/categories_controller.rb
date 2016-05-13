class CategoriesController < ApplicationController

  before_action :find_category, only: [:show, :edit, :update, :destroy, :graph, :transactions]

  def index
    @categories = Category.order(:name)
    @pies = [{ points: @categories.map { |category| {key: category.name, y: category.total.abs.to_f} } }]
  end

  def show

  end

  def new
    @category = Category.new
  end

  # months (javascript date) and amount
  def graph
    @data = @category.d3_graph_points

    @series = [{ values: @data, key: @category.name }]

    @title = "Spending for #{@category.name}"
  end

  def trends
    @series = []

    Category.all.each do |category|
      data = category.d3_graph_points

      @series << { values: data, key: category.name }
    end

    @title = 'Overall spending trends'

    render 'graph'
  end

  def transactions
    @transactions = @category.transactions
  end

  def create
    @category = Category.new(category_params)
    @category.save ? redirect_to(@category) : render(:new)
  end

  def edit

  end

  def update
    @category.update(category_params) ? redirect_to(@category) : render(:edit)
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, notice: 'Category successfully destroyed.'
    else
      redirect_to categories_path, flash: {error: 'Failed to destroy category.'}
    end
  end

  private

  def find_category
    begin
      @category = Category.find(params[:id].to_i)
    rescue
      # what
    end
  end

  def category_params
    category_hash(params.require(:category))
  end

  def category_hash(hash)
    hash.permit(:name, :graph, source_ids: [], purpose_ids: [])
  end
end
