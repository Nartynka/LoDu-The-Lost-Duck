extends Node2D

const seconds_per_day:int = 86400 # 60 * 60 * 24
const HOUR = 60 * 60

#export(float, 0, 1) var brightness_night = 0.3
#export(float, 0, 1) var brightness_day = 1.0
export(Color) var color_dawn = Color("494688")
export(Color) var color_day = Color("fff1d0")
export(Color) var color_dusk = Color("854646")
export(Color) var color_night = Color("27264c")

enum TimeOfDay {AUTO, DAWN, DAY, DUSK, NIGHT}
export(TimeOfDay) var time_of_day = TimeOfDay.AUTO

signal time_of_day_change(frame)
signal color_changed(color)

var is_day : bool = true setget set_is_day

var dawn_start:float = HOUR * 4.0 # starts at 4 o'clock
var dusk_start:float = HOUR * 18.0 # start at 18 o'clock
var sunrise_start:float
var sunrise_end:float
var sunset_start:float
var sunset_end:float
var day_start
var night_start

var color_gradient:Gradient = Gradient.new()

var current_color:Color = color_night

func _ready():
	randomize()
	Clock.connect("time_passed", self, "_on_time_passed")
	
	# starts at sun*_start and end 1 hour later
	sunrise_start = dawn_start / seconds_per_day
	sunrise_end = float(dawn_start+HOUR) / seconds_per_day
	sunset_start = dusk_start / seconds_per_day
	sunset_end = float(dusk_start+HOUR) / seconds_per_day
	
	color_gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CUBIC
	
	day_start = float(dawn_start + (HOUR * 3)) / seconds_per_day
	night_start = float(dusk_start + (HOUR * 3)) / seconds_per_day
	
	color_gradient.remove_point(1)
	color_gradient.set_color(0, color_night)
	color_gradient.add_point(sunrise_start, color_night)
	color_gradient.add_point(sunrise_end, color_dawn)
	color_gradient.add_point(day_start, color_day)
	color_gradient.add_point(sunset_start, color_day)
	color_gradient.add_point(sunset_end, color_dusk)
	color_gradient.add_point(night_start, color_night)


# when time passes, we calculate the brightness and tint of the environment
# based on the current time of day
func _on_time_passed():
	if time_of_day != TimeOfDay.AUTO:
		return

	var time = Clock.time
	var day_time = int(time) % seconds_per_day
	var point := float(day_time)/seconds_per_day
	
	current_color = color_gradient.interpolate(point)
	# apply color
	emit_signal("color_changed", current_color)
	sunrise_start = stepify(sunrise_start, 0.001)
	sunrise_end = stepify(sunrise_end, 0.001)
	day_start = stepify(day_start, 0.001)
	sunset_start = stepify(sunset_start, 0.001)
	sunset_end = stepify(sunset_end, 0.001)
	night_start = stepify(night_start, 0.001)
	point = stepify(point, 0.001)

	match point:
		0.0:
			emit_signal("time_of_day_change", 7)
			self.is_day = false
		sunrise_start:
			emit_signal("time_of_day_change", 0)
			self.is_day = false
		sunrise_end:
			emit_signal("time_of_day_change", 1)
			self.is_day = true
		day_start:
			emit_signal("time_of_day_change", 2)
			self.is_day = true
		sunset_start:
			emit_signal("time_of_day_change", 3)
			self.is_day = false
		sunset_end:
			emit_signal("time_of_day_change", 4)
			self.is_day = false
		night_start:
			emit_signal("time_of_day_change", 5)
			self.is_day = false

func _process(_delta):
	if time_of_day != TimeOfDay.AUTO:
		match_timeOfDay()

func match_timeOfDay():
	match TimeOfDay.keys()[time_of_day]:
		"DAWN":
			emit_signal("color_changed", color_dawn)
			emit_signal("time_of_day_change", 0)
			self.is_day = false
		"DAY":
			emit_signal("color_changed", color_day)
			emit_signal("time_of_day_change", 2)
			self.is_day = true
		"DUSK":
			emit_signal("color_changed", color_dusk)
			emit_signal("time_of_day_change", 4)
			self.is_day = false
		"NIGHT":
			emit_signal("color_changed", color_night)
			emit_signal("time_of_day_change", 7)
			self.is_day = false


func set_is_day(new_value):
	yield(get_tree().create_timer(0.7), "timeout")
	is_day = new_value
