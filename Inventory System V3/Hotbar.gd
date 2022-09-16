extends Control

const SlotClass = preload("res://Inventory System V3/Slot.gd")
onready var hotbar_slots = $HotbarSlots
onready var active_item_label = $ActiveItemLabel
onready var slots = hotbar_slots.get_children()

func _ready():
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
	PlayerInventory.connect("active_item_updated", self, "update_active_item_label")
	for i in range(slots.size()):
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].slotType = SlotClass.SlotType.HOTBAR
	initialize_hotbar()
	update_active_item_label()

func update_active_item_label():
#	if slots[PlayerInventory.active_item_slot].item != null:
#		active_item_label.text = slots[PlayerInventory.active_item_slot].item.item_name
#	else:
#		active_item_label.text = ""
	pass
func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])

func _input(event):
	if get_parent().holding_item:
		get_parent().holding_item.global_position = get_global_mouse_position()

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if get_parent().holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if get_parent().holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)
			update_active_item_label()

func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(get_parent().holding_item, slot)
	slot.putIntoSlot(get_parent().holding_item)
	get_parent().holding_item = null
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(get_parent().holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(get_parent().holding_item)
	get_parent().holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= get_parent().holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, get_parent().holding_item.item_quantity)
		slot.item.add_item_quantity(get_parent().holding_item.item_quantity)
		get_parent().holding_item.queue_free()
		get_parent().holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		get_parent().holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	get_parent().holding_item = slot.item
	slot.pickFromSlot()
	get_parent().holding_item.global_position = get_global_mouse_position()

