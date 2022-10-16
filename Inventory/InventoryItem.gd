extends Node2D

var item_name
var item_quantity

func _ready():
	var rand_val = randi() % 3
	item_name = "Gold Coin"
#	$TextureRect.texture = load("res://item_icons/" + item_name + ".png")
#	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	var stack_size = 64
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = String(item_quantity)

func set_item(name, quantity):
	item_name = name
	item_quantity = quantity
#	$TextureRect.texture = load("res://item_icons/" + item_name + ".png")
	JsonData.item_data = JsonData.loadData()
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
	
