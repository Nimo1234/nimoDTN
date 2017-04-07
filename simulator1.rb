#
#
# 
require './objects.rb'

def calc_interval(number_events)
	interval = 60.0/number_events # temporal solution, IMPROVE

	return (interval)
end


class Eventlist
	attr_accessor :events,:path,:station_id1,:station_id2

	def initialize()
		@events = Array.new
	end

	def create_GENDATA(time, data_id, sensor_id, datasize)
		# Creating Events
		info = [data_id, sensor_id, datasize]
		event = [time, "GENDATA", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end

	
	def create_TRANSDATA(time0, data_id, sensor_id,data_size, station_id)
		# Creating Events
		info = [time0, data_id, sensor_id, data_size, station_id]
		event = [time0, "TRANSDATA", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end
  
	def create_RECVDATA(time1, data_id, sensor_id, data_size,station_id)
		# Creating Events
		info = [time1, data_id, sensor_id, data_size, station_id]
		event = [time1, "RECVDATA", info] # [TIME, EVENT_TYPE, INFORMATION]
		@events.push(event)
	end
  
  # arrival and departure bus events
  
  def create_BUSARRIVAL(time0,station_id,bus_id)# defining   bus movement model with parameterlist
  		# Creating Events
  		info = [station_id,bus_id]
  		event = [time0, "BUSARRIVAL", info] # [TIME, EVENT_TYPE, INFORMATION]
  		@events.push(event)
  	end
  
  
  def create_BUSDEPART(time1,station_id,bus_id)# defining   bus movement model with parameterlist
    # Creating Events
  	info = [station_id,bus_id]
  	event = [time1, "BUSDEPART", info] # [TIME, EVENT_TYPE, INFORMATION]
  	@events.push(event)
  end 
   
  def create_STOP(time3,station_id,bus_id)# defining   bus movement model with parameterlist
    # Creating Events
  	info = [station_id,bus_id]
  	event = [time3, "BUSSTOP", info] # [TIME, EVENT_TYPE, INFORMATION]
  	@events.push(event)
  end
  
  def create_MOVE(time4,station_id,bus_id)# defining   bus movement model with parameterlist
    # Creating Events
  	info = [station_id,bus_id]
  	event = [time4, "BUSSTOP", info] # [TIME, EVENT_TYPE, INFORMATION]
  	@events.push(event)
  end
  
  # add path for the bus 
	def add_path(station_id1,station_id2, minutes)
		action = ["MOVE", station_id1, station_id2, minutes]
		@path.push(action)
	end

	def add_stop(station_id,bus_id,minutes)
		action = ["STOP",station_id,bus_id,minutes]
		@path.push(action)
	end
  
  

	def sort()
		@events = @events.sort do |a,b| a[0] <=> b[0] end
	end

	def print()
		@events.each do |event|
			p event
		end
	end
	
end


class ArrayObject < Array
  def getInstances(strId)
    elements = self.select do |elem|
		elem.id == strId
  end

	return (elements[0])
end


class ArrayObj < Array
  def getInstances(strId)
    elements = self.select do |elem|
		elem.id == strId
  end

	return (elements[0])
end
end
end   


# Initialization
NUM_STATIONS=4
NUM_SENSORS=10
NUM_BUSES=4
TIME_FINISH = 180 # Finish time in Seconds
TOTAL_TIME_TRAVEL=110

# Creating Stations and Sensors
list_stations = Array.new
list_sensors = ArrayObject.new
k = 0
for i in 0..(NUM_STATIONS-1) do
	station_id = sprintf("station-%03d", i)
	station = Station.new(station_id)
	list_stations.push(station)
	
	for j in 0..(NUM_SENSORS-1) do
	    sensor_id = sprintf("sensor-%03d", k)
		#sensor = Sensor.new(sensor_id, "Video", 2)
		sensor = Sensor.new(sensor_id, station_id)
		station.add_sensor(sensor)
		list_sensors.push(sensor)

#		printf("Station:[%s] Sensor:[%s]\n", station_id, sensor_id)
		k += 1
	end
end

# Event: Data generation
eventlist = Eventlist.new()
count_data = 0
list_stations.each do |station|
	sensors = station.get_sensors()
	sensors.each do |sensor|
		time = 0.0
		while (time < TIME_FINISH) do
	  		data_id = sprintf("Data%08d", count_data)
	  		data = sensor.create_data(data_id)
	  		interval = sensor.calc_interval()
	  		count_data += 1

			# Creating Events
			eventlist.create_GENDATA(time, data_id, sensor.id, data.size)

			time += interval
		end

	end
end

# adding bus event to eventlist 

# Event(TRANSDATA): Data transmission from Sensor to Station
eventlist.sort()
eventlist.events.each do |event|
  if (event[1] == "GENDATA") then
    #p event
	# check sensor id
	sensor_id = event[2][1]
  
	# find station id from the sensor id
  # find bus id from station id 
	## 1. instance of sensor with the sensor_id
	sensor_obj = list_sensors.getInstances(sensor_id)

  station_id = sensor_obj.station_id
  data_id =event[2][0]
  data_size=event[2][2]


	# create data transfer event from sensor to station
	# [0.0, "GENDATA", ["Data00000170", "sensor-025", 1024]]
	# [time, "TRANSDATA", [Data-ID, Data-originate-sensor-ID, size, Received ID]]
	# Creating Events
  #time0=time
	time0 = event[0]# time generated during the data generation 
	eventlist.create_TRANSDATA(time0, data_id, sensor_id, data_size, station_id)

	time1 = time0+1
	eventlist.create_RECVDATA(time1, data_id, sensor_id, data_size, station_id)
  end

end


eventlist.sort()
eventlist.events.each do |event|
  p event
end

#eventlist.print()


###
# Bus movement

# Bus preparation, Array for keeping bus instances

#@list_buses=Array.new
list_buses = Array.new # for bus instances
# creating bus array objects 
bus1 = Bus.new("bus-001")
bus2 = Bus.new("bus-002")
bus3 = Bus.new("bus-003")
bus4 = Bus.new("bus-004")




def getstationid(bus_id)
  @bus_id=bus_id
  return bus_id
end
=begin
def bus1.add_path(station_id1, station_id2,miutes)# station_id 
def bus1.add_stop(station_id1, bus_id,minutes)# station_id
def bus2.add_path(station_id1, station_id2,minutes)#
def bus2.add_stop(station_id2, bus_id,minutes)
def bus3.add_path(station_id1, station_id2,minutes)# station_id 
def bus3.add_stop(station_id1, bus_id,minurtes)# station_id
def bus4.add_path(station_id2, station_id1,minutes)#
def bus4.add_stop(station_id1, bus_id,minutes)#
end
end
end
end
end
end
end
end
=end 

 bus1.add_path(@station_id1, @station_id2,20)# station_id 
 bus1.add_stop(@station_id2, @bus_id,40)# station_id
 bus2.add_path(@station_id1, @station_id2,20)#
 bus2.add_stop(@station_id2, @bus_id,60)
 bus3.add_path(@station_id1, @station_id2,20)# station_id 
 bus3.add_stop(@station_id1, @bus_id,80)# station_id
 bus4.add_path(@station_id1, @station_id2,20)#
 bus4.add_stop(@station_id1, @bus_id,110)#
 
 

 
 
 









# Bus Arriva/,Bus Departure and Bus stop event generation 
eventlist =  Eventlist.new()
list_buses = [bus1, bus2, bus3, bus4]
count_bus = 0
time=0.0

list_buses.each do |bus|
  list_stations.each do |station|
  
  while(time < TOTAL_TIME_TRAVEL)
    bus_id = sprintf("bus%08d", count_bus)
    count_bus+= 1
   
    #list_buses = bus.create_bus(bus_id)
    #interval = bus.calc_interval()
			# Creating Events
      
      time = TOTAL_TIME_TRAVEL+5
		  eventlist.create_BUSARRIVAL(time,station_id,bus_id)

		  time1 = TOTAL_TIME_TRAVEL+25
		  eventlist.create_BUSDEPART(time1, station_id,bus_id)

		  time2 =TOTAL_TIME_TRAVEL+35
		  eventlist.create_STOP(time2,station_id,bus_id)

		  time3 =TOTAL_TIME_TRAVEL+50
		  eventlist.create_MOVE(time3, station_id,bus_id)

      end
      p bus
      #p station
      #p list_buses
    end
  end 
eventlist.sort()
eventlist.events.each do |event|
  p event
  #p bus
  end
  




#nooooteeeee
# create bus id from  instance id variable ()
# loop NUM_BUS (for)
#   bus generation
#   
#

# pass = [["StationID", 40], ["

# path = [ ["A", "B". 20], ["B", "B" 30], 
# create 
