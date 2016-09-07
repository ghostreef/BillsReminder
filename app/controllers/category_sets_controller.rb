class CategorySetsController < ApplicationController

  before_action :find_set, only: [:show, :edit, :update, :destroy, :graph, :transactions]

  def index
    @sets = CategorySet.order(:name)
    flash[:notice] = "Transaction Grand Total: $#{Transaction.grand_total}"
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

      # data = Transaction.where(date: date.beginning_of_month..date.end_of_month).joins(:categories).where(categories: {id: @set.categories.pluck(:id)})
      #            .group('categories.name').select('categories.name as name, abs(sum(transactions.amount)) as total')
      #
      #
      #
      # raise data.inspect

      data = @set.categories.map do |category|
        {key: category.name, y: category.total(date.beginning_of_month, date.end_of_month).to_f}
      end

      title = "#{I18n.t("date.abbr_month_names")[date.month]} #{date.year}"

      @pies << {title: title, points: data }
    end
  end

  # don't lke this, fix later, should be in transactions controller, should avoid trees
  def transactions
    case params[:name]
      when 'missing'
        @transactions = @set.missing_transactions
      when 'overlapping'
        @transactions = @set.overlapping_transactions
      else
        @transactions = []
    end

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
    category_set_hash(params.require(:category_set))
  end

  def category_set_hash(hash)
    hash.permit(:name, category_ids: [])
  end
end
