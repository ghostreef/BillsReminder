class ParsersController < ApplicationController

  before_action :find_parser, only: [:show, :edit, :update, :destroy, :enable]

  def index
    @parsers = Parser.order(:name)
  end

  def show

  end

  def new
    @parser = Parser.new
  end

  def edit

  end

  def create
    @parser = Parser.new(parser_params)
    @parser.save ? redirect_to(@parser) : render(:new)
  end

  def update
    @parser.update(parser_params) ? redirect_to(@parser) : render(:edit)
  end
  
  def destroy
    if @parser.destroy
      redirect_to parsers_path, notice: 'Parser successfully destroyed.'
    else
      redirect_to parsers_path, flash: { error: 'Failed to destroy parser.' }
    end
  end

  def enable
    @parser.enable
    redirect_to parsers_path
  end

  private

  def find_parser
    begin
      @parser = Parser.find(params[:id].to_i)
    rescue
      # what
    end
  end

  def parser_params
    parser_hash(params.require(:parser))
  end

  def parser_hash(hash)
    hash.permit(:name, :status, search_order: [], expected_order: [], transformation_ids: [])
  end
end
