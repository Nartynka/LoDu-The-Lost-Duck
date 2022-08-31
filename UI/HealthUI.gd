extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartsFull = $HeartsFull
onready var heartsEmpty = $HeartsEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartsFull != null:
		heartsFull.rect_size.x = 13 * hearts

func set_max_hearts(value):
	# max - return biggest number
	# max_hearts cannot be less than 1
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartsEmpty != null:
		heartsEmpty.rect_size.x = 13 * max_hearts
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	# connect to signal from stats.gd and set hearts
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
