extends Node

onready var thunderLayer = $ThunderLayer
onready var cloudsLayer = $CloudsLayer
onready var rainParticles = $RainParticles

export(bool) var rain = false setget set_rain
export(int) var rain_amount = 2000 setget set_rain_amount

export(float, 0, 1) var cloud_speed:float = 0.03 setget set_cloud_speed
export(float, 0, 1) var cloudiness:float = 2 setget set_cloudiness

export(bool) var thunder = false
export(float, 0, 1) var thunder_strength_rand_min:float = 0.2
export(float, 0, 1) var thunder_strength_rand_max:float = 1
var lightning_strike_on:bool = false
var color_add:Color = Color(0, 0, 0, 0)
export(int) var time_multipler = 3600 setget set_time_multipler

func _process(_delta):
	if thunder:
		var thunder_strength = rand_range(thunder_strength_rand_min, thunder_strength_rand_max)
		if lightning_strike_on:
			if color_add.r <= 0.01:
				lightning_strike_on = false
			else:
				color_add *= 0.9
		else:
			print("A")
			lightning_strike()
#			var thunder_random = RandomNumberGenerator.new()
#			var rand = abs(thunder_random.randfn(0, 1))
#			if rand < thunder_strength * 0.1:
#				lightning_strike()
		thunderLayer.color += color_add
		var timer = get_tree().create_timer(2)
		if timer.time_left >= 0:
			thunderLayer.color = Color("ffffff")

func lightning_strike():
	lightning_strike_on = true
	var a = rand_range(0.2, 0.8)
	color_add = Color(a, a, a, 0)

func set_rain(new_value):
	rain = new_value
	if rainParticles:
		rainParticles.amount = rain_amount
		rainParticles.set_emitting(new_value)

func set_rain_amount(new_value):
	rain_amount = new_value
	rainParticles.amount = rain_amount

func set_cloud_speed(new_value):
	cloud_speed = new_value
	cloudsLayer.shader_param.time_scale_1 = new_value

func set_cloudiness(new_value):
	cloudiness = new_value
	cloudsLayer.shader_param.tile_factor_1 = cloudiness
	
func set_time_multipler(new_value):
	time_multipler = new_value
	Clock.time_multiplier = new_value
