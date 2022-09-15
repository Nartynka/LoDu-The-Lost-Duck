extends Control

onready var inventoryContainer = $NinePatchRect/GridContainer

func _ready():
	Inventory.connect("inventory_change", self, "update_inventory") 


func _input(event):
	if event.is_action_pressed("inventory"):
		if visible:
			hide()
		else:
			show()

func _on_Button_pressed():
	hide()

func update_inventory(item_name, amount):
#	var Item = load("res://Items/"+item_name+"/"+item_nem+".tscn")
#	var Item = preload("res://Inventory/InventoryItem.tscn")
#	var item = Item.instance()
#	item.name = item_name
#	item.item_name = item_name
#	item.texture_path = "res://Items/GoldCoin/coin.png"
#	inventoryContainer.add_child(item)
	prints(item_name, amount)
