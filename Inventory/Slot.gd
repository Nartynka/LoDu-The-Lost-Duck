extends Panel

var Coin = preload("res://Items/GoldCoin/Coin.tscn")
var item = null
var default_stylebox = get_stylebox("panel")

func _ready():
	if randi()% 2 == 0:
		var item = Coin.instance()
		item.monitoring = false
		item.position += Vector2(8,8)
		item.scale = Vector2(0.7, 0.7)
		add_child(item)

var ItemClass = preload("res://Items/Item.tscn")

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	SHIRT,
	PANTS,
	SHOES,
}

var slotType = null
var slot_index


func pickFromSlot():
	remove_child(item)
	find_parent("UI").add_child(item)
	item = null

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	find_parent("UI").remove_child(item)
	add_child(item)

func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)

func _on_Slot_mouse_entered():
	var stylebox = get_stylebox("panel").duplicate()
	stylebox.region_rect.position.x = 16
	add_stylebox_override("panel", stylebox)

func _on_Slot_mouse_exited():
	add_stylebox_override("panel", default_stylebox)
