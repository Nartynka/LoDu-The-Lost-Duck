extends Node

signal active_item_updated

const SlotClass = preload("res://Inventory/Slot.gd")
const ItemClass = preload("res://Inventory/InventoryItem.gd")
const INVENTORY_SLOTS = 20
const HOTBAR_SLOTS = 5

var active_item_slot = 0

# slot_index: [item_name, item_quantity]
# 0: ["Gold Coin", 2],
var inventory = {
}

var hotbar = {
#	0: ["Gold Coin", 2],
}

#var equips = {
#	0: ["Brown Shirt", 1],  #--> slot_index: [item_name, item_quantity]
#	1: ["Blue Jeans", 1],  #--> slot_index: [item_name, item_quantity]
#	2: ["Brown Boots", 1],	
#}

# TODO: First try to add to hotbar
func add_item(item_name, item_quantity):
	var slot_indices: Array = inventory.keys()
	slot_indices.sort()
	for item in slot_indices:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity = item_quantity - able_to_add
	
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return

########## Manipulate inventory through code

func get_item(item_name) -> int:
	for i in inventory:
		if inventory[i][0] == item_name:
			return inventory[i][1]
	return 0

func remove_item(item_name, item_quantity = 1):
	for i in inventory:
		if inventory[i][0] == item_name:
			inventory.erase(i)

##### VISUAL
func update_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().get_nodes_in_group("Slot")[slot_index+1]
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func remove_item_from_slot(slot: SlotClass):
	match slot.SlotType:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
#		_:
#			equips.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.SlotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
#		_:
#			equips[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.SlotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
#		_:
#			equips[slot.slot_index][1] += quantity_to_add



### Hotbar Style update
func active_item_scroll_up() -> void:
	var previous = active_item_slot
	active_item_slot = (active_item_slot + 1) % HOTBAR_SLOTS
	emit_signal("active_item_updated", previous)

func active_item_scroll_down() -> void:
	var previous = active_item_slot
	if active_item_slot == 0:
		active_item_slot = HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated", previous)





