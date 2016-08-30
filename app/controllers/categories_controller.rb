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
    if params[:commit] == 'SUBMIT'
      @category.save ? redirect_to(@category) : render(:new)
    elsif params[:commit] == 'PREVIEW'
      s_ids = params[:category][:source_ids].reject(&:empty?)
      p_ids = params[:category][:purpose_ids].reject(&:empty?)

      # it is not possible to do category.transaction because this category has no id for the mapping table
      @transactions = Transaction.where{(source_id.in s_ids) | (purpose_id.in p_ids)}
      render(:new)
    end
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

  def delete_all
    ActiveRecord::Base.connection.execute('DELETE * FROM categories_purposes')
    ActiveRecord::Base.connection.execute('DELETE * FROM categories_sources')
    Category.delete_all
  end

  def seed
    file = File.read('data/categories.json')
    data = JSON.parse(file)

    purposes = Purpose.pluck(:name, :id).to_h
    sources = Source.pluck(:name, :id).to_h

    data.each do |datum|
      purpose_ids = purposes.values_at(*datum['purposes'])
      source_ids = sources.values_at(*datum['sources'])
      Category.create(category_hash(datum).merge(purpose_ids: purpose_ids, source_ids: source_ids))
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
    hash.permit(:name, :graph, :category_set_id, source_ids: [], purpose_ids: [])
  end
end
