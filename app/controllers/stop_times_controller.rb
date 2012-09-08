class StopTimesController < ApplicationController
  def index
    sid = params[:starting_id] if params[:starting_id]
    did = params[:destination_id] if params[:destination_id]
    if sid.present? && did.present? && sid.to_i != did.to_i
      trips = Trip.all(stop_ids: [sid.to_i, did.to_i]).where(direction: sid.to_i < did.to_i ? 0 : 1)
      @stop_times = StopTime.in(stop_id: [sid.to_i], trip_id: trips.map(&:id).map(&:to_i)).gte(arrival_time: Time.now.to_i).asc(:arrival_time)
    else
      id = sid.present? ? sid.to_i : 1
      @stop_times = StopTime.where(stop_id: id).gte(arrival_time: Time.now.to_i).asc(:arrival_time)
    end
    
    respond_to do |format|
      format.js
      format.html
    end      
  end
  def show
    @stop_time = StopTime.find_by(id: params[:id])
  end
end