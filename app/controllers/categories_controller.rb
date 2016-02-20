class CategoriesController < ApplicationController

  before_action :find_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.order(:name)
  end

  def show

  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.save ? redirect_to(@category) : render(:new)
  end

  def edit

  end

  def update
    @category.update(category_params) ? redirect_to(@category) : render(:edit)
  end

  def destroy
    if @category.destroy
      redirect_to categories_url, notice: 'Category successfully destroyed.'
    else
      redirect_to categories_path, flash: { error: 'Failed to destroy category.' }
    end
  end

  private

  def find_category
    begin
      @category = Category.find(params[:id].to_i)
    rescue
      # what
    end
  end

  def category_params
    category_hash(params.require(:category))
  end

  def category_hash(hash)
    hash.permit(:name)
  end
end
