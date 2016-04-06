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
      t.errors.empty? ? "#{t.regex} created successfully." : t.custom_error_messages
    end

    redirect_to transformations_path, flash: { notices: results }
  end

  def update
    @transformation.update(transformation_params) ? redirect_to(@transformation) : render(:edit)
  end

  def update_many
    redirect_to transformations_path and return if params[:transformations].nil?

    flash[:success] = []
    flash[:errors] = []

    params[:transformations].map do |k,v|
      transformation = Transformation.find(k.to_i)
      transformation.update(transformation_hash(v))

      if transformation.errors.empty?
        flash[:success] << transformation.id
      else
        flash[:errors] << "Transformation #{transformation.id} did not update. Details: #{transformation.custom_error_messages.join(', ')}"
      end
    end

    flash[:success] = "#{ActionController::Base.helpers.pluralize(flash[:success].count, 'Transformation')} #{flash[:success].join(', ')} successfully updated." unless flash[:success].length == 0

    redirect_to transformations_path
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
    hash.permit(:regex, :derives, :value, :implies, :set, :case_insensitive, :transformation_id)
  end
end
