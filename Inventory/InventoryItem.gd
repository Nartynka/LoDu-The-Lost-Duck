extends Control

export(String) var texture_path
export(String) var item_name

onready var sprite = $Sprite

func _ready():
	sprite.texture = load(texture_path)
