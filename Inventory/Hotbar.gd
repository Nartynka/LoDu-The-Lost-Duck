extends Control

const SlotClass = preload("res://Inventory/Slot.gd")

onready var activeItemLabel = $Control/ActiveItemLabel
onready var slots = $InventoryBg/HotbarSlots.get_children()
onready var labelAnimation = $Control/LabelAnimation

onready var default_stylebox = slots[0].get_stylebox("panel")

func _ready():
	for slot in slots:
		slot.connect("gui_input", self, "slot_gui_input", [slot])
		slot.slotType = SlotClass.SlotType.HOTBAR

	PlayerInventory.connect("active_item_updated", self, "update_style")
	initialize_hotbar()
	update_active_item_label()

func update_style(previous_index):
	var previous_slot = slots[previous_index]
	previous_slot.add_stylebox_override("panel", default_stylebox)
	
	var slot = slots[PlayerInventory.active_item_slot]
	var stylebox = slot.get_stylebox("panel").duplicate()
	stylebox.region_rect.position.x = 18
	slot.add_stylebox_override("panel", stylebox)
	
	update_active_item_label()

func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		activeItemLabel.text = slots[PlayerInventory.active_item_slot].item.item_name
		labelAnimation.play("show")

func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])

func _input(event):
	if get_parent().holding_item:
		get_parent().holding_item.global_position = get_global_mouse_position()

	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()

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
	PlayerInventory.remove_item_from_slot(slot)
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
	PlayerInventory.remove_item_from_slot(slot)
	get_parent().holding_item = slot.item
	slot.pickFromSlot()
#	print(get_parent())
	get_parent().holding_item.global_position = get_global_mouse_position()
