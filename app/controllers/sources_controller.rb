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

  def create_many
    results = params[:sources].map do |source|
      s = Source.create(source_hash(source))
      s.errors.empty? ? "#{s.name} created successfully." : s.custom_error_messages
    end

    redirect_to sources_url, notice: results.flatten
  end

  def update
    @source.update(source_params) ? redirect_to(@source) : render(:edit)
  end

  def update_many
    results = params[:sources].map do |k,v|
      source = Source.find(k.to_i)
      source.update(source_hash(v))
      source.errors.empty? ? "Source #{source.id} successfully updated." : "Source #{source.id} did not update."
    end

    redirect_to sources_url, notice: results
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
      # what
    end
  end

  def source_params
    source_hash(params.require(:source))
  end

  def source_hash(hash)
    hash.permit(:name, :regex, :purpose_id)
  end
end
