extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerStats.from_scene != null:
		$"%Player".set_position(get_node(PlayerStats.from_scene+"Pos").position)
#	$"%Player".position = PlayerStats.spawn_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
