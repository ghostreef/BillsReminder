class TransactionsController < ApplicationController

  before_action :find_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @start_date = params.fetch(:start_date, Date.today - 1.month)
    @end_date = params.fetch(:end_date, Date.today)

    @transactions = Transaction.where(date: @start_date..@end_date).order(:date)
  end

  def show

  end

  def new
    @transaction = Transaction.new
  end

  def edit

  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.save ? redirect_to(@transaction) : render(:new)
  end

  def update
    @transaction.update(transaction_params) ? redirect_to(@transaction) : render(:edit)
  end
  
  def destroy
    if @transaction.destroy
      redirect_to transactions_path, notice: 'Transaction successfully destroyed.'
    else
      redirect_to transactions_path, flash: { error: 'Failed to destroy transaction.' }
    end
  end

  def import
    # error check
    if params[:file].nil?
      redirect_to transactions_path, notice: 'No file uploaded.' and return
    end

    # error check
    unless params[:file].original_filename =~ /\.csv$/
      redirect_to transactions_path, notice: 'Invalid format.' and return
    end

    # to be sure
    flash.clear
    flash[:success] = flash[:error] = 0
    flash[:errors] = []

    # begin parsing file
    require 'CSV'
    CSV.foreach(params[:file].tempfile, headers: true) do |row|

      # generates a row hash using headers as keys
      # assumes commas are the delimiters
      row_hash = row.to_hash

      # the problem with this is that the headers are the keys, and the keys may change
      date = Transaction.format_date(row_hash['Date'])
      amount = Transaction.format_amount(row_hash['Amount'])
      transaction = Transaction.new(date: date, amount: amount, raw_description: row_hash['Description'])

      if transaction.save
        flash[:success] += 1
      else
        flash[:error] += 1
        flash[:errors] << "#{$.} #{row}"
      end

    end

    flash[:error] = flash[:error] > 0 ? "Error adding #{flash[:error]} transactions." : nil
    flash[:success] = "#{flash[:success]} transactions added successfully." if flash[:success] > 0

    redirect_to transactions_path
  end

  def parse
    if params[:all] == 'true'
      transactions = Transaction.all
      message = 'Re-parsed all transactions.'
    else
      # sanitize input
      ids = params[:transaction_ids].map {|id| id.to_i}
      transactions = Transaction.find(ids)
      message = "Re-parsed these transactions: #{transactions.map(&:id).join(', ')}."
    end

    transactions.each do |transaction|
      transaction.parse
    end

    redirect_to transactions_path, notice: message
  end

  def breakdown
    # lets default to the last 6 months
    # key: category.name, y: amount
    # title is month

    @pies = []

    (0..5).step(1) do |num|
      date = Date.today - num.months
      data = Transaction.where(date: date.beginning_of_month..date.end_of_month).joins(:categories)
              .group('categories.name').select('categories.name as name, sum(transactions.amount) as total')

      title = "#{I18n.t("date.abbr_month_names")[date.month]} #{date.year}"

      @pies << {title: title, points: data_to_pie_graph(data)}
    end

  end

  private

  def data_to_pie_graph(data)
    data.map { |point| { key: point.name, y: point.total.to_f } }
  end

  def find_transaction
    begin
      @transaction = Transaction.find(params[:id].to_i)
    rescue
      # what
    end
  end

  def transaction_params
    transaction_hash(params.require(:transaction))
  end

  def transaction_hash(hash)
    hash.permit(:date, :amount, :raw_description, :source_id, :purpose_id)
  end

end
