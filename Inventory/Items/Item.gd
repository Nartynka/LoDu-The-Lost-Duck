extends Area2D

export(String) var item_name = "Gold_Coin"
export(Texture) var inventory_texture

func _on_Item_body_entered(body):
	if body.name == "Player":
		$AudioStreamPlayer.play()
		PlayerInventory.add_item(item_name, 1)
		hide()
		set_deferred("monitoring", false)
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
