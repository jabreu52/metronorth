class StopsController < ApplicationController
  def index
    @stops = Stop.where(name: /#{params[:name].strip}/i)
    respond_to do |format|
      format.json { render json: @stops, callback: params[:callback] }
    end      
  end
end