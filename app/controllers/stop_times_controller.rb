class StopTimesController < ApplicationController
  def index
    sid = params[:starting_id] if params[:starting_id]
    did = params[:destination_id] if params[:destination_id]
    
    if Time.now.sunday?
      t = Trip.in(service_id: [2,3,6])
    elsif Time.now.monday?
      t = Trip.in(service_id: [1,2])
    elsif Time.now.tuesday? || Time.now.wednesday? || Time.now.thursday?
      t = Trip.where(service_id: 1)  
    elsif Time.now.friday?
      t = Trip.in(service_id: [1,6])
    elsif Time.now.saturday?
      t = Trip.in(service_id: [3,4])
    end
    
    if sid.present? && did.present? && sid.to_i != did.to_i
      trips = t.all(stop_ids: [sid.to_i, did.to_i]).where(direction: sid.to_i < did.to_i ? 0 : 1)
      @stop_times = StopTime.where(stop_id: sid.to_i).in(trip_id: trips.map(&:id)).gte(arrival_time: Time.now.to_i).asc(:arrival_time)
    else
      id = sid.present? ? sid.to_i : 1
      current_time = (Time.now.hour * 60) + Time.now.min
      @stop_times = StopTime.where(stop_id: id).in(trip_id: t.map(&:id)).gte(arrival_time: current_time).asc(:arrival_time)
    end
    
    respond_to do |format|
      format.js
      format.json { render json: @stop_times, callback: params[:callback] }
      format.html
    end      
  end
  def show
    @stop_time = StopTime.find_by(id: params[:id])
  end
end