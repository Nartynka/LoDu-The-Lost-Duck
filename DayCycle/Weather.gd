extends Node

onready var dayNight = $DayNight
onready var cloudLayer = $CloudLayer
onready var rainParticles = $RainParticles

export(bool) var rain = false setget start_rain
export(int) var rain_amount = 1000
export(bool) var thunder = false setget start_thunderstorm
export(float, 0, 1) var thunder_strength:float = rand_range(0.2, 1)
export(float, 0, 1) var cloud_speed:float = 0.1 setget set_cloud_speed
export(float, 0, 1) var cloudiness_factor:float = 0.5 setget set_cloudiness
enum TimeOfDay{
	AUTO,
	DAWN,
	DAY,
	DUSK,
	NIGHT
}

export(TimeOfDay) var FixedTimeOfDay = TimeOfDay.AUTO

func start_rain(new_value):
	rain = new_value
	rainParticles.amount = rain_amount
	rainParticles.set_emitting(new_value)

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
