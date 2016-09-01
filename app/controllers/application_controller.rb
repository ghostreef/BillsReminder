class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def dashboard

  end

  def seed
    s = SeedApplication.new
    s.obliterate
  end
end
