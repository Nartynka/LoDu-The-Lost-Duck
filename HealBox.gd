extends Area2D

func _on_HealBox_body_entered(body):
	PlayerStats.health = PlayerStats.max_health
