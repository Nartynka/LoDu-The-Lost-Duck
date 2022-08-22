extends Node

export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

var spawnpoint
var previous_scene

signal no_health
signal player_death
signal health_changed(value)
signal max_health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health<=0:
		emit_signal('no_health')
		emit_signal('player_death')

func set_max_health(value):
	max_health = value
	# min - returns smaller number
	# health cannot be grater than max_health
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func _ready():
	self.health = max_health
