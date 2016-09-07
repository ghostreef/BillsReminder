class PurposesController < ApplicationController

  before_action :find_purpose, only: [:edit, :update, :destroy]

  def index
    @purposes = Purpose.order(:name)
  end

  def create_many
    results = params[:purposes].map do |purpose|
      p = Purpose.create(purpose_hash(purpose))
      p.errors.empty? ? "Purpose '#{p.name}' successfully created." : p.custom_error_messages
    end

    redirect_to purposes_path, flash: { notices: results }
  end

  def edit
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    response = {}

    if @purpose.update(purpose_params)
      response['success'] = 'Purpose updated.'
      response['purpose'] = @purpose
    else
      response['errors'] = 'Failed to update purpose.'
    end

    # do @purposes.errors.empty? ? redirect_to purposes_path : render 'edit' end
    respond_to do |format|
      format.json { render json: response }
      format.html { redirect_to purposes_path }
    end
  end
  
  def destroy
    if @purpose.destroy
      redirect_to purposes_path, notice: 'Purpose successfully destroyed.'
    else
      flash[:error] = 'Failed to destroy purpose.'
      redirect_to purposes_path
    end
  end

  private

  def find_purpose
    begin
      @purpose = Purpose.find(params[:id].to_i)
    rescue
      # what
    end
  end

  def purpose_params
    purpose_hash(params.require(:purpose))
  end

  def purpose_hash(hash)
    hash.permit(:name, :default)
  end
end
