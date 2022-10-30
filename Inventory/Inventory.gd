extends Control

const SlotClass = preload("res://Inventory/Slot.gd")
onready var slots = $GridContainer.get_children()
onready var equip_slots = $EquipSlots.get_children()

func _ready():
	for slot in slots:
		slot.connect("gui_input", self, "slot_gui_input", [slot])
		slot.slotType = SlotClass.SlotTypes.INVENTORY
		slot.slotIndex = slots.find(slot)
	initialize_inventory()
	
	for slot in equip_slots:
		slot.connect("gui_input", self, "slot_gui_input", [slot])
		slot.slotIndex = slots.find(slot)
		
	equip_slots[0].slotType = SlotClass.SlotTypes.HELMET
	equip_slots[1].slotType = SlotClass.SlotTypes.SHIRT
	equip_slots[2].slotType = SlotClass.SlotTypes.PANTS
	equip_slots[3].slotType = SlotClass.SlotTypes.SHOES
	initialize_equips()

func initialize_inventory():
	for slot in slots:
		var i = slot.slotIndex
		if PlayerInventory.inventory.has(i):
			slot.initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func initialize_equips():
	for slot in equip_slots:
		var i = slot.slotIndex
		if PlayerInventory.equips.has(i):
			slot.initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])

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
				
func _input(event):
	if get_parent().holding_item:
		get_parent().holding_item.global_position = get_global_mouse_position()

	if event.is_action_pressed("inventory"):
		visible = !visible
	elif event.is_action_pressed("ui_cancel"):
		visible = false

		
func able_to_put_into_slot(slot: SlotClass):
	var holding_item = get_parent().holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	
	if slot.slotType == SlotClass.SlotTypes.HELMET:
		return holding_item_category == "Helmet"
	elif slot.slotType == SlotClass.SlotTypes.SHIRT:
		return holding_item_category == "Shirt"
	elif slot.slotType == SlotClass.SlotTypes.PANTS:
		return holding_item_category == "Pants"
	elif slot.slotType == SlotClass.SlotTypes.SHOES:
		return holding_item_category == "Shoes"
	return true
		
func left_click_empty_slot(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(get_parent().holding_item, slot)
		slot.putIntoSlot(get_parent().holding_item)
		get_parent().holding_item = null
	
func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item_from_slot(slot)
		print("aaa")
		PlayerInventory.add_item_to_empty_slot(get_parent().holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(get_parent().holding_item)
		get_parent().holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
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
	get_parent().holding_item.global_position = get_global_mouse_position()


func _on_CloseButton_pressed():
	visible = false
