extends CanvasModulate

const NIGHT_COLOR = Color("#394778")
const DAY_COLOR = Color("#ffffff")
const TIME_SCALE = 0.1

onready var sprite = $"../Sprite"

var time = 0
func _process(delta):
	time += delta * TIME_SCALE
	color = NIGHT_COLOR.linear_interpolate(DAY_COLOR, abs(sin(time)))
#	print(color.to_html())
	match color.to_html():
		"ffffffff":
			sprite.frame = 0
#			print("dzien")
		"ffe1e3ea":
			sprite.frame = 1
#			print("zachod 1")
		"ffa5abc2":
			sprite.frame = 2
#			print("zachod 2")
		"ffe1e399":
			sprite.frame = 3
#			print("zachod finall")
		"ff828baa":
			sprite.frame = 4
#			print("noc 1")
		"ff475481":
			sprite.frame = 5
#			print("noc 2")
		"ff3f4d7c":
			sprite.frame = 6
#			print("noc finall")
