extends Node2D

# ONLY loading (preloading) scene (we don't do anything on it)
# Grass effect scene - not node (packed scene)
const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	# Grass effect instance of scene - node
	# Instancing scene - creating node (we work on this)
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	# set grassEffect position to grass position
	grassEffect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
