extends Resource
class_name DateTime

var time:float

var second:int
var minute:int
var hour:int
var day:int
var year:int

func _init(time):
	self.time = time
	var int_time = int(floor(time)) # time is a decimal so we'll round it.

	second = int_time % 60
	minute = (int_time / 60) % 60
	hour = (int_time / (60 * 60)) % 24
	day = 1 + ((int_time / (60 * 60 * 24)) % 365)
	year = (int_time / (60 * 60 * 24 * 365))

# For debug use and later ui
func get_timestamp(withSeconds: bool = true) -> String:
	var string = "Year " + str(year) + ", Day " + str(day) + " at " + get_time_string(withSeconds)
	return string

func get_time_string(withSeconds: bool = true) -> String:
	var hour = self.hour
	var minute = self.minute
	var second = self.second
	
	if hour < 10:
		hour = "0" + str(hour)
	if minute < 10:
		minute = "0" + str(minute)
	if second < 10:
		second = "0" + str(second)
		
	var string = str(hour) + ":" + str(minute)
	if withSeconds:
		string += ":" + str(second)
	
	return string
