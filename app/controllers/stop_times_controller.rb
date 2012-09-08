class StopTimesController < ApplicationController
  def index
    sid = params[:starting_id]
    did = params[:destination_id]
    if sid.present? && did.present? && sid != did
      trips = Trip.all(stop_ids: [sid, did]).where(direction: sid.to_i < did.to_i ? 0 : 1)
      @stop_times = StopTime.in(stop_id: sid, trip_id: trips.map(&:id)).gte(arrival_time: Time.now.to_i).asc(:arrival_time)
    else
      id = sid.present? ? sid : 1
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