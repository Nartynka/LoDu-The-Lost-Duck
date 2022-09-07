extends CanvasModulate

const seconds_per_day:int = 86400 # 60 * 60 * 24
const HOUR = 60 * 60

#export(float, 0, 1) var brightness_night = 0.3
#export(float, 0, 1) var brightness_day = 1.0
export(Color) var color_dawn = Color("494688")
export(Color) var color_day = Color("fff1d0")
export(Color) var color_dusk = Color("854646")
export(Color) var color_night = Color("27264c")
enum TimeOfDay{AUTO, DAWN, DAY, DUSK, NIGHT}
export(TimeOfDay) var time_of_day = TimeOfDay.AUTO

onready var DayNightCompas = $CanvasLayer/Daynight
onready var TimeLabel = $CanvasLayer/Time
onready var DayLabel = $CanvasLayer/Day


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
	color = current_color
	sunrise_start = stepify(sunrise_start, 0.001)
	sunrise_end = stepify(sunrise_end, 0.001)
	day_start = stepify(day_start, 0.001)
	sunset_start = stepify(sunset_start, 0.001)
	sunset_end = stepify(sunset_end, 0.001)
	night_start = stepify(night_start, 0.001)
	point = stepify(point, 0.001)

	match point:
		0.0:
			DayNightCompas.frame = 7
		sunrise_start:
			DayNightCompas.frame = 0
		sunrise_end:
			DayNightCompas.frame = 1
		day_start:
			DayNightCompas.frame = 2
		sunset_start:
			DayNightCompas.frame = 3
		sunset_end:
			DayNightCompas.frame = 4
		night_start:
			DayNightCompas.frame = 5

func _process(_delta):
	DayLabel.text = Clock.get_day_string()
	TimeLabel.text = Clock.get_time_string()
	if time_of_day != TimeOfDay.AUTO:
		match TimeOfDay.keys()[time_of_day]:
			"DAWN":
				color = color_dawn
				DayNightCompas.frame = 0
			"DAY":
				color = color_day
				DayNightCompas.frame = 2
			"DUSK":
				color = color_dusk
				DayNightCompas.frame = 4
			"NIGHT":
				color = color_night
				DayNightCompas.frame = 7
