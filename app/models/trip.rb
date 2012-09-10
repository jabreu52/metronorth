class Trip
  include Mongoid::Document
  has_many :stop_times
  has_and_belongs_to_many :stops
  
  field :_id, type: Integer, default: ->{ trip_id }
  field :trip_id, type: Integer
  field :service_id, type: Integer
  field :headsign, type: String
  field :direction, type: Integer
  
  def status(sid, did)
    did.present? && did != sid ? "Departing" : direction == 0 ? "Departing" : "Arriving"
  end
  
  def responsive_status
    direction == 0 ? "D" : "A"
  end
  
  def line_name
    headsign + " Line"
  end
end
