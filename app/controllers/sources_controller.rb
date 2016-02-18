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

    if @source.save
      redirect_to @source
    else
      render 'new'
    end
  end


  def update
    if @source.update(source_params)
      redirect_to @source
    else
      render 'edit'
    end
  end


  def destroy
    if @source.destroy
      redirect_to sources_url, notice: 'Source successfully destroyed.'
    else
      flash[:error] = 'Failed to destroy source.'
      redirect_to sources_path
    end
  end

  private

  def find_source
    @source = Source.find(params[:id].to_i)
  end

  def source_params
    params.require(:source).permit(:name, :regex)
  end

end
