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
    if params[:file].nil?
      redirect_to transactions_path, notice: 'No file uploaded.' and return
    end

    unless params[:file].original_filename =~ /\.csv$/
      redirect_to transactions_path, notice: 'Invalid format.' and return
    end

    require 'CSV'
    file_path = params[:file].tempfile

    success_count = error_count = 0
    flash[:successes] = flash[:errors] = []


    CSV.foreach(file_path, headers: true) do |row|
      r = row.to_hash

      begin
        date = Date.strptime(r['Date'], '%m/%d/%Y')
      rescue
        error_count+=1
        flash[:errors] << "#{$.} #{row}"
        next
      end

      amount = r['Amount'].tr('-$','').to_f.abs.round(2)

      raw_description = r['Description']

      t = Transaction.create(date: date, amount: amount, raw_description: raw_description)

      if t.errors.empty?
        success_count+=1
      else
        error_count+=1
        flash[:errors] << "#{$.} #{row}"
      end
    end

    if error_count > 0
      flash[:error] = "Error adding #{error_count} transactions."
    end

    if success_count > 0
      flash[:success] = "#{success_count} transactions added."
    end

    redirect_to transactions_path
  end

  private

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
