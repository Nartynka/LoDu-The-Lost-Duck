extends CanvasModulate

const seconds_per_day:int = 86400 # 60 * 60 * 24
const seconds_per_hour:int = 3600 # 60 * 60
const HOUR = 60 * 60
export(float, 0, 1) var brightness_night = 0.3
export(float, 0, 1) var brightness_day = 1.0
export(Color) var color_dawn = Color("494688")
export(Color) var color_day = Color("fff1d0")
export(Color) var color_dusk = Color("854646")
export(Color) var color_night = Color("27264c")

var dawn_start:float = HOUR* 4.0 # starts at 4 o'clock
var dusk_start:float = HOUR* 18.0 # start at 18 o'clock

var sunrise_start:float
var sunrise_end:float
var sunset_start:float
var sunset_end:float

var color_gradient:Gradient = Gradient.new()

var color_add:Color = Color(0, 0, 0, 0)

var current_color:Color = color_night

var cloudiness_factor:float = 0
var thunderstorm_enabled:bool = false
var thunderstorm_strength:float = 0.2
var lightning_strike_on:bool = false

var thunder_random:RandomNumberGenerator = RandomNumberGenerator.new()

enum TimeOfDay{
	AUTO,
	DAWN,
	DAY,
	DUSK,
	NIGHT
}

export(TimeOfDay) var time_of_day = TimeOfDay.AUTO

func _ready():
	randomize()
	Clock.connect("time_passed", self, "_on_time_passed")
	
	# starts at sun*_start and end 1 hour later
	sunrise_start = dawn_start / seconds_per_day
	sunrise_end = float(dawn_start+HOUR) / seconds_per_day
	sunset_start = dusk_start / seconds_per_day
	sunset_end = float(dusk_start+HOUR) / seconds_per_day
	
	color_gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CUBIC
	
	var day_start = float(dawn_start + (HOUR * 3)) / seconds_per_day
	var night_start = float(dusk_start + (HOUR * 3)) / seconds_per_day
	
	color_gradient.remove_point(1)
	color_gradient.set_color(0.0, color_night)
	color_gradient.add_point(sunrise_start, color_night)
	color_gradient.add_point(sunrise_end, color_dawn)
	color_gradient.add_point(day_start, color_day)
	color_gradient.add_point(sunset_start, color_day)
	color_gradient.add_point(sunset_end, color_dusk)
	color_gradient.add_point(night_start, color_night)
#	$Sprite.texture.gradient = color_gradient
#	print(color_gradient.interpolate(sunrise_start+0.01).to_html(false))
	
# when time passes, we calculate the brightness and tint of the environment
# when time passes, we calculate the brightness and tint of the environment
# based on the current time of day
func _on_time_passed(t):
	if time_of_day != TimeOfDay.AUTO:
		return
	var time = Clock.time

	var time_of_day = int(time) % seconds_per_day
	current_color = color_gradient.interpolate(float(time_of_day) / seconds_per_day)

	# apply color
	color = current_color

	# add color add
	color += color_add
	# add cloudiness
	if cloudiness_factor > 0.5:
		var a = (cloudiness_factor - 0.5) * 2.0
		color = color.linear_interpolate(color.darkened(0.5), a)


func lightning_strike():
	lightning_strike_on = true
	var a = rand_range(0.2, 0.8)
	color_add = Color(a, a, a, 0)


func _process(delta):
	if time_of_day != TimeOfDay.AUTO:
		match time_of_day:
			"DAWN":
				color = color_dawn
			"DAY":
				color = color_day
			"DUSK":
				color = color_dusk
			"NIGHT":
				color = color_night
	if thunderstorm_enabled:
		if lightning_strike_on:
			if color_add.r <= 0.01:
				lightning_strike_on = false
			else:
				color_add *= 0.9
		else:
			var rand = abs(thunder_random.randfn(0, 1))
			if rand < thunderstorm_strength * 0.1:
				lightning_strike()
