extends Node

onready var dayNight = $DayNight
onready var cloudLayer = $CloudLayer
onready var rainParticles = $RainParticles

export(bool) var rain = false setget start_rain
export(int) var rain_amount = 2000 setget set_rain_amount
export(bool) var thunder = false setget start_thunderstorm
export(float, 0, 1) var thunder_strength_rand_min:float = 0.2
export(float, 0, 1) var thunder_strength_rand_max:float = 1
export(float, 0, 1) var cloud_speed:float = 0.1 setget set_cloud_speed
export(float, 0, 1) var cloudiness_factor:float = 0.5 setget set_cloudiness
export(int) var time_multipler = 3600 setget set_time_multipler
var thunder_strength:float

enum TimeOfDay{
	AUTO,
	DAWN,
	DAY,
	DUSK,
	NIGHT
}

export(TimeOfDay) var time_of_day = TimeOfDay.AUTO setget set_timeofday

func _process(delta):
	thunder_strength = rand_range(thunder_strength_rand_min, thunder_strength_rand_max)

func start_rain(new_value):
	rain = new_value
	if rainParticles:
		rainParticles.amount = rain_amount
		rainParticles.set_emitting(new_value)

func set_rain_amount(new_value):
	rain_amount = new_value
	rainParticles.amount = rain_amount

func start_thunderstorm(new_value):
	thunder = new_value
	if dayNight:
		dayNight.thunderstorm_strength = thunder_strength
		dayNight.thunderstorm_enabled = new_value

func set_cloud_speed(new_value):
	cloud_speed = new_value
	cloudLayer.get_node("ParallaxLayer/AnimationPlayer").playback_speed = cloud_speed

func set_cloudiness(new_value):
	cloudiness_factor = new_value
	var clouds = cloudLayer.get_node("ParallaxLayer")
	if cloudiness_factor < 0.5:
		clouds.modulate.a = cloudiness_factor
	else:
		clouds.modulate.a = 1 - cloudiness_factor
	
	dayNight.cloudiness_factor = cloudiness_factor
	
func set_time_multipler(new_value):
	time_multipler = new_value
	Clock.time_multiplier = new_value
	
func set_timeofday(new_value):
	time_of_day = new_value
	if dayNight:
		dayNight.time_of_day = TimeOfDay.keys()[time_of_day]
