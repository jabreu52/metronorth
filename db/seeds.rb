require 'csv'

puts "Add Stop Times"
CSV.foreach('db/data/stop_times.csv', {headers: true}) do |row|
  stop_id = row[3].to_i
  arrival_time = Chronic.parse(row[1].length < 8 ? "0#{row[1]}" : row[1]).to_i
  departure_time = Chronic.parse(row[2].length < 8 ? "0#{row[2]}" : row[2]).to_i
  stop_sequence = row[4].to_i
  unless StopTime.where(stop_id: stop_id, arrival_time: arrival_time, stop_sequence: stop_sequence).present?  
    StopTime.create!(
      stop_id: stop_id,
      trip_id: row[0].to_i,
      arrival_time: arrival_time,
      departure_time: departure_time,
      stop_sequence: stop_sequence
    )
  end
end

puts "Add Stops"
CSV.foreach('db/data/stops.csv', {headers: true}) do |row|
  Stop.create!(
    stop_id: row[0].to_i,
    name: row[2],
    trip_ids: StopTime.where(stop_id: row[0].to_i).map(&:trip_id)
  )
end

puts "Add Trips"
CSV.foreach('db/data/trips.csv', {headers: true}) do |row|
  Trip.create!(
    trip_id: row[2].to_i,
    headsign: row[3],
    direction: row[5].to_i,
    stop_ids: StopTime.where(trip_id: row[2].to_i).map(&:stop_id)
  )
end