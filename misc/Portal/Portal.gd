extends Area2D

export(String, FILE, "*.tscn") var to_scene = ""
export(String) var to_spawnpoint = "spawnpoint"
export(String) var spawnpoint_name = "spawnpoint"

# Portal MUST be placed above player in scene tree, idk why but doesn't work if below player
# Portal is in Portals gorup, spawnpoint is in spawnpoints group

func _ready():
	if to_spawnpoint == "spawnpoint":
		to_spawnpoint = get_tree().current_scene.name+"Pos"
	if spawnpoint_name == "spawnpoint":
		spawnpoint_name = name+"Pos"
	if is_in_group("portals"):
		get_child(0).name = spawnpoint_name

func _on_Portal_body_entered(body):
	if body is Player:
		if  to_scene == "":
			push_error("Error changing scenes: to_scene has no assigned scene")
			return false
		PlayerStats.spawnpoint = to_spawnpoint
		PlayerStats.previous_scene = get_tree().current_scene.name
		SceneChange.change_scene(to_scene)
