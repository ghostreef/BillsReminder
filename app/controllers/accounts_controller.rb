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

  # this is for practice
  def create_and_update_many
    results =  params[:accounts].map do |account|
      if account[:id]
        existing_account = Account.find(account[:id])
        existing_account.update(account_hash(account)) ? "Account #{existing_account.name} successfully updated." : "Error updating account #{existing_account.name}."
      else
        new_account = Account.new(account_hash(account))
        new_account.save ? "Account #{new_account.name} successfully created." : "Error creating account #{new_account.name}."
      end
    end

    redirect_to accounts_path, flash: { notices: results }
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
    account_hash.require(:account)
  end

  def account_hash(hash)
    hash.permit(:username, :name, :hint)
  end
end
