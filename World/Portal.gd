extends Area2D

export(String, FILE, "*.tscn, *.scn") var EndScene

func _on_Portal_body_entered(body):
	if(body.name == "Player"):
		if(!EndScene): 
			print("No scene in this portal")
			return
		get_tree().change_scene(EndScene)
