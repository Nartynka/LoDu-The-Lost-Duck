extends Node

export var item_data: Dictionary

func _ready():
	item_data = loadData("res://Data/ItemData.json")

func loadData(file_path="res://Data/ItemData.json"):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result
