class CategorySetsController < ApplicationController

  before_action :find_set, only: [:show, :edit, :update, :destroy, :graph, :missing]

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
    # points = @set.categories.map { |category| { key: category.name, y: category.total.to_f } }
    # @pies = [title: @set.name, points: points]
    # TODO refactor, sql doesn't work on purposes
    @pies = []

    (0..2).step(1) do |num|
      date = Date.today - num.months

      data = Transaction.joins(:categories).where(categories: {id: @set.categories.pluck(:id)})
                 .group('categories.name').select('categories.name as name, abs(sum(transactions.amount)) as total')



      title = "#{I18n.t("date.abbr_month_names")[date.month]} #{date.year}"

      @pies << {title: title, points: data.map { |point| { key: point.name, y: point.total.to_f } }}
    end
  end

  def graph_date
    @set = CategorySet.find(params[:id].to_i)


  end

  def missing
    @transactions = @set.missing

    respond_to do |format|
      format.js
      format.html
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
