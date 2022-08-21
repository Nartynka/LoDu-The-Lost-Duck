extends Area2D

export(String, FILE, "*.tscn") var EndScene

func _on_Portal_body_entered(body):
	if(body.name == "Player"):
		if(!EndScene): 
			print("No scene in this portal")
			return
		PlayerStats.from_scene = get_tree().current_scene.name
		SceneChange.change_scene(EndScene)
