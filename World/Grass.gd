extends Node2D

func create_grass_effect():
	# Grass effect scene - not node (packed scene)
	# ONLY loading scene (we don't do anything on it)
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	# Grass effect instance of scene - node
	# Instancing scene - creating node (we work on this)
	var grassEffect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	# set grassEffect position to grass position
	grassEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
