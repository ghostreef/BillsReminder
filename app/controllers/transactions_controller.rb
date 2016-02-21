class TransactionsController < ApplicationController

  before_action :find_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = Transaction.order(:date).limit(30)
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
      redirect_to transactions_url, notice: 'Transaction successfully destroyed.'
    else
      redirect_to transactions_path, flash: { error: 'Failed to destroy transaction.' }
    end
  end

  private

  def find_transaction
    begin
      @transaction = Transaction.find(params[:id].to_i)
    rescue
      # what
    end
  end

  def transactions_params
    transaction_hash(params.require(:transaction))
  end

  def transaction_hash(hash)
    hash.permit(:date, :amount, :raw_description, :source_id, :purpose_id)
  end

end
