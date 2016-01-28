class BillsController < ApplicationController
  def index
    @bills = Bill.all.order(:due_date)
  end

  def dashboard
    @bills = Bill.where{((paid.eq false) & (due_date <= Date.today)) | ({due_date: (Date.today - 1.week)..(Date.today + 2.weeks) }) }.order(:due_date)
    render 'index'
  end

  def paid
    bill = Bill.find(params[:bill][:id].to_i)

    new_bill = bill.dup
    new_bill.due_date += 1.month
    new_bill.paid = false
    new_bill.save

    bill.paid = true
    bill.save
    # without action rails runs this action 6 times ??
    redirect_to action: 'dashboard'
  end

  def show
    @bill = Bill.find(params[:id].to_i)
  end

  def new
    @bill = Bill.new
  end

  def edit
    @bill = Bill.find(params[:id].to_i)
  end

  def create
    @bill = Bill.new(bill_params)

    if @bill.save
      redirect_to @bill
    else
      render 'new'
    end
  end


  def update
    @bill = Bill.find(params[:id].to_i)

    if bill_params[:paid]
      new_bill = @bill.dup
      new_bill.due_date += 1.month
      new_bill.save
    end

    if @bill.update(bill_params)
      redirect_to @bill
    else
      render 'edit'
    end
  end


  def destroy
    @bill = Bill.find(params[:id].to_i)
    @bill.destroy

    redirect_to bills_path
  end

  private

  def bill_params
    params.require(:bill).permit(:issuer, :bill_type, :amount, :term_number, :term_unit, :due_date, :description, :paid, :auto_pay)
  end

end
