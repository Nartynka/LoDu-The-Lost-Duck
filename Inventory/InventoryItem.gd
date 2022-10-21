extends Node2D

var item_name
var item_quantity
var item_texture

onready var textureRect = $TextureRect
onready var label = $Label

func set_item(name, quantity):
	item_name = name
	item_quantity = quantity
	set_texture()
	JsonData.item_data = JsonData.loadData()
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		label.visible = false
	else:
		label.visible = true
		label.text = String(item_quantity)

func set_texture():
	var file = File.new()
	if file.file_exists("res://Inventory/Items Icon/" + item_name + ".tres"):
		textureRect.texture = load("res://Inventory/Items Icon/" + item_name + ".tres")
	elif file.file_exists("res://Inventory/Items Icon/" + item_name + ".png"):
		textureRect.texture = load("res://Inventory/Items Icon/" + item_name + ".png")
	else:
		print_debug("Missing item inventory icon")
		textureRect.texture = load("res://Inventory/Items Icon/Gold Coin.tres")

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	label.text = String(item_quantity)
