extends Camera2D

#onready var player = $"../ViewportContainer/Viewport/World/Camera2D"
onready var player = get_node("../../../ViewportContainer/Viewport/World/YSort/Player")
func _ready():
	transform.origin.x = player.transform.origin.x
	transform.origin.y = player.transform.origin.y
