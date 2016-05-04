class AccountsController < ApplicationController

  before_action :find_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = Account.order(:name)
  end

  def show

  end

  def new
    @account = Account.new
  end

  def edit

  end

  def create
    @account = Account.new(account_params)

    @account.save ? redirect_to(@account) : render(:new)
  end

  def update
    @account.update(account_params) ? redirect_to(@account) : render(:edit)
  end

  def destroy
    if @account.destroy
      redirect_to accounts_path, notice: 'Account successfully destroyed.'
    else
      redirect_to accounts_path, flash: {error: 'Failed to destroy account.'}
    end
  end

  private

  def find_account
    begin
      @account = Account.find(params[:id].to_i)
    rescue
      # what
    end
  end

  def account_params
    params.require(:account).permit(:username, :name, :hint)
  end
end
