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

#func update(dateTime:DateTime):
#	return self.second == dateTime.second and self.minute == dateTime.minute and dateTime.hour == hour and self.day == dateTime.day
	
# For debug use and later ui
func print_string(withSeconds: bool = true) -> String:
	var hour = self.hour
	var minute = self.minute
	var second = self.second

	if hour < 10:
		hour = "0" + str(hour)
	if minute < 10:
		minute = "0" + str(minute)
	if second < 10:
		second = "0" + str(second)

	var string = "Year " + str(year) + ", Day " + str(day) + " at " + str(hour) + ":" + str(minute)
	if withSeconds:
		string += ":" + str(second)
	
	print(string)
	return string
