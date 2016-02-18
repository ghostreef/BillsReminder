class PurposesController < ApplicationController

  def index
    @purposes = Purpose.all.order(:name)
  end

  def create_many
    @results = params[:purposes].map do |purpose|
      p = Purpose.create(purpose.permit(:name))
      p.errors.empty? ? "#{p.name} successfully created." : p.custom_error_messages
    end

    redirect_to purposes_path
  end

  def edit
    @purpose = Purpose.find(params[:id].to_i)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    @purpose = Purpose.find(params[:id].to_i)
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
      format.html
    end
  end



  def destroy
    @purpose = Purpose.find(params[:id].to_i)
    if @purpose.destroy
      redirect_to purposes_url, notice: 'Purpose successfully destroyed.'
    else
      flash[:error] = 'Failed to destroy purpose.'
      redirect_to purposes_path
    end
  end

  private

  def purpose_params
    params.require(:purpose).permit(:name)
  end
end
