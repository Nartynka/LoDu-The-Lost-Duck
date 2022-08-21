extends Node2D

func _ready():
	VisualServer.set_default_clear_color(Color("#000000"))
#	$YSort/Player.position = $WorldPos.position
	if PlayerStats.from_scene != null:
		$"%Player".set_position(get_node(PlayerStats.from_scene+"Pos").position)
