extends Panel
class_name SlotClass

export(int) var move_x = 16
var ItemClass = preload("res://Inventory/InventoryItem.tscn")
var item = null
#var slot_index : int = 0

var default_stylebox = get_stylebox("panel")

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
#	SHIRT,
#	PANTS,
#	SHOES,
}

var slotType = null

#func _ready():
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)

func pickFromSlot():
	remove_child(item)
	get_owner().get_parent().add_child(item)
	item = null
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	get_owner().get_parent().remove_child(item)
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
	stylebox.region_rect.position.x = move_x
	add_stylebox_override("panel", stylebox)

func _on_Slot_mouse_exited():
	add_stylebox_override("panel", default_stylebox)
