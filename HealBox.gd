extends Area2D

onready var area = $"."

func _on_HealBox_body_entered(body):
	area.damage = 0
	PlayerStats.health = PlayerStats.max_health
