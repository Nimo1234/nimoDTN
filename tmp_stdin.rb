
 
station = Hash.new
#bus=Hash.new
bus1=Hash.new
bus   = Hash.new
#station.merge!(bus)
line = ""
while (line != nil) do
	line = STDIN.gets
	
	# Processing for line
  #event =line.split(",")
  #def try
  #a = nil.try(:split, ",")
  
#  event = line.split(/\s/).map(&:to_i)
  next if line == nil
  event = line.split(",")
#p event
  #event = line.split(",")
  

  if (event[1] == "RECVDATA") then
    p event
    size = event[4]
    station_id =event[5]
    data_id = event[2]
    sensor_id = event[3]
    #p node_id

    if (station[station_id] == nil)
      station[station_id] = Array.new
    end
    station[station_id].push([data_id, sensor_id, size])
  end
  if (event[1] == "BUSARRIVAL") then
    p event
    #size = event[4]
    station_id1 =event[3]
    station_id2 =event[4]
    bus_id = event[2]
    #sensor_id = event[3]
    if (bus[bus_id] == nil)
      bus[ bus_id] = Array.new
     #row_hash=bus[("rec #{counter}")]=Hash.new 
  end 
   bus[bus_id].push(station_id1,station_id2)
end 

if(event[1]=="BUSSTOP") then 
  p event
  bus_id=event[2]
  station_id=event[3]
  
  if(bus1[bus_id]==nil)
    bus1[bus_id]=Array.new
  end 
  bus1[bus_id].push(station_id)
end 
#  puts("--------")
end
p bus1 
bus1.each_key do |key,value|
  p key
  p value 
  
end 
p bus
bus.each_key do |key,value|
  p key
  p value
end 
p station
station.each_key do |key,value|
  p key
  p value
end




    
    
  


