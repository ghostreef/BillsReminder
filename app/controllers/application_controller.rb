class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :helpful_tips
  def dashboard

  end

  def seed
    s = SeedApplication.new
    s.obliterate
    s.seed
    redirect_to dashboard_path
  end

  def helpful_tips
    if Purpose.count == 0
      flash[:notice] ='First things first. Create some purposes for your transactions. Every transaction has a purpose.'
    elsif Source.count == 0
      flash[:notice] ='Next create some sources. Sources show where a transaction originated from, it can be a person, location, or business.'
    elsif Transaction.count == 0
      flash[:notice] = "Looks like you're ready to begin uploading some transactions."
    elsif Category.count == 0
      flash[:notice] = 'Categories help show you how much of your money is going where. Now that you have some transactions, group them into categories. A category will encompass some set of source(s) and/or purpose(s).'
    elsif CategorySet.count == 0
      flash[:notice] = "Categories are not always mutually exclusive and sometimes it's helpful to group categories multiple ways to see trends in spending. Use sets to group your categories into mutually exclusive sets."
    end
  end
end
