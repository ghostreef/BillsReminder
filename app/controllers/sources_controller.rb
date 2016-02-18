class SourcesController < ApplicationController

  before_action :find_source, only: [:show, :edit, :update, :destroy]

  def index
    @sources = Source.all.order(:name)
  end

  def show

  end

  def new
    @source = Source.new
  end

  def edit

  end

  def create
    @source = Source.new(source_params)
    @source.save ? redirect_to(@source) : render(:new)
  end


  def update
    @source.update(source_params) ? redirect_to(@source) : render(:edit)
  end


  def destroy
    if @source.destroy
      redirect_to sources_url, notice: 'Source successfully destroyed.'
    else
      redirect_to sources_path, flash: { error: 'Failed to destroy source.' }
    end
  end

  private

  def find_source
    begin
      @source = Source.find(params[:id].to_i)
    rescue

    end
  end

  def source_params
    params.require(:source).permit(:name, :regex)
  end

end
