class TransformationsController < ApplicationController

  before_action :find_transformation, only: [:show, :edit, :update, :destroy]

  def index
    @transformations = Transformation.all
  end

  def show

  end

  def new
    @transformation = Transformation.new
  end

  def edit

  end

  def create
    @transformation = Transformation.new(transformation_params)
    @transformation.save ? redirect_to(@transformation) : render(:new)
  end

  def create_many
    results = params[:transformations].map do |transformation|
      t = Transformation.create(transformation_hash(transformation))
      t.errors.empty? ? "#{t.pattern} created successfully." : t.custom_error_messages
    end

    redirect_to transformations_path, flash: { notices: [results.flatten] }
  end

  def update
    @transformation.update(transformation_params) ? redirect_to(@transformation) : render(:edit)
  end

  def update_many
    redirect_to transformations_path and return if params[:transformations].nil?

    results = params[:transformations].map do |k,v|
      transformation = Transformation.find(k.to_i)
      transformation.update(transformation_hash(v))
      transformation.errors.empty? ? "Transformation #{transformation.id} successfully updated." : "Transformation #{transformation.id} did not update. #{transformation.custom_error_messages.join(', ')}"
    end

    redirect_to transformations_path, notice: results
  end

  def destroy
    if @transformation.destroy
      redirect_to transformations_path, notice: 'Transformation successfully destroyed.'
    else
      redirect_to transformations_path, flash: { error: 'Failed to destroy transformation.' }
    end
  end

  private

  def find_transformation
    begin
      @transformation = Transformation.find(params[:id].to_i)
    rescue
      # what
    end
  end

  def transformation_params
    transformation_hash(params.require(:transformation))
  end

  def transformation_hash(hash)
    hash.permit(:pattern, :transform, :value, :case_insensitive, :transformation_type)
  end
end
