extends Control

onready var slots = [$InventoryBg/Slot, $InventoryBg/Slot2, $InventoryBg/Slot3, $InventoryBg/Slot4, $InventoryBg/Slot5]

onready var active = slots[0] setget set_active

func _ready():
	var inv = Inventory.list()
	print(inv)
#	slots.item = inv[0]

func _input(event):
	var inv = Inventory.list()
	print(inv.get(0))
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if active == slots[4]:
					self.active = slots[0]
				else:
					self.active = slots[clamp(slots.find(active)+1, 0, slots.size()-1)]
			if event.button_index == BUTTON_WHEEL_DOWN:
				self.active = slots[slots.find(active)-1]
	if event is InputEventKey:
		for i in range(0, slots.size()):
			if event.is_action_pressed(String(i+1)):
				self.active = slots[i]

func set_active(new_value):
	active.frame = 0
	active = new_value
	active.frame = 1
