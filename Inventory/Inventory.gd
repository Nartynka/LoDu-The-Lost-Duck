extends Control

func _input(event):
	if event.is_action_pressed("action"):
		if visible:
			hide()
		else:
			show()


func _on_Button_pressed():
	hide()
