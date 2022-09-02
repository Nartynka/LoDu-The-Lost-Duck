extends Panel

var stylebox

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


func _on_Slot_mouse_entered():
	var stylebox = get_stylebox("panel").duplicate()
	stylebox.region_rect.position.x = 16
	add_stylebox_override("panel", stylebox)

func _on_Slot_mouse_exited():
	add_stylebox_override("panel", default_stylebox)
