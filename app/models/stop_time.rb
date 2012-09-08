class StopTime
  include Mongoid::Document
  belongs_to :stop
  belongs_to :trip
  
  field :_id, type: String
  field :arrival_time, type: Float
  field :departure_time, type: Float
  field :stop_sequence, type: Integer

  def as_json(options={})
    { id: self._id, arrival_time: self.arrival_time, departure_time: self.departure_time, stop_sequence: self.stop_sequence }
  end

  def stop_name(id)
    Stop.find_by(id: id).name
  end
    
  def arrival_time_strf(id)
    time = StopTime.find_by(stop_id: id, trip_id: trip_id).arrival_time
  	Time.at(time).strftime("%l:%M%P")
  end  

  def departure_time_strf
    Time.at(departure_time).strftime("%l:%M%P")
  end 
  
  def peak?
    if stop_id = 1 || stop_id = 4
      arrival_hour = Time.at(arrival_time).hour
      ((5..10).member?(arrival_hour) && trip.direction == 1) || 
      ((5..9).member?(arrival_hour) && trip.direction == 0) ||
      ((16..20).member?(arrival_hour) && trip.direction == 0)
    else
      false
    end
  end 
  
  def travel_time(id)
    time = StopTime.find_by(stop_id: id, trip_id: trip_id).arrival_time
    "#{(time - departure_time) / 60} min"
  end
end
