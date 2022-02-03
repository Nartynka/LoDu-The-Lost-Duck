extends CanvasLayer

func _ready():
	PlayerStats.connect("no_health", self, "respawn")
	set_visible(false)

func respawn():
	set_visible(true)
	get_tree().paused = true

func set_visible(is_visable):
	for node in get_children():
		node.visible = is_visable

func _on_Respawn_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
	PlayerStats.health = PlayerStats.max_health
	set_visible(false)

func _on_Quit_pressed():
	get_tree().quit()
