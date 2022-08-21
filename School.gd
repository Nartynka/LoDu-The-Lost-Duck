extends Node2D

func _ready():
	if PlayerStats.from_scene != null:
		$"%Player".set_position(get_node(PlayerStats.from_scene+"Pos").position)
