require 'csv'

puts "Add Stop Times"
CSV.foreach('db/data/stop_times.csv', {headers: true}) do |row|
  stop_id = row[3]
  arrival_time = Chronic.parse(row[1].length < 8 ? "0#{row[1]}" : row[1]).to_i
  departure_time = Chronic.parse(row[2].length < 8 ? "0#{row[2]}" : row[2]).to_i
  stop_sequence = row[4].to_i
  unless StopTime.where(stop_id: stop_id, arrival_time: arrival_time, stop_sequence: stop_sequence).present?  
    StopTime.create!(
      stop_time_id: row[7],
      stop_id: stop_id,
      trip_id: row[0],
      arrival_time: arrival_time,
      departure_time: departure_time,
      stop_sequence: stop_sequence
    )
  end
end

puts "Add Stops"
CSV.foreach('db/data/stops.csv', {headers: true}) do |row|
  Stop.create!(
    stop_id: row[0],
    name: row[2],
    trip_ids: StopTime.where(stop_id: row[0]).map(&:trip_id)
  )
end

puts "Add Trips"
CSV.foreach('db/data/trips.csv', {headers: true}) do |row|
  Trip.create!(
    trip_id: row[2],
    headsign: row[3],
    direction: row[5],
    stop_ids: StopTime.where(trip_id: row[2].to_i).map(&:stop_id)
  )
end