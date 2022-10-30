extends CanvasLayer

func _ready():
	set_visible(false)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if !UI.get_child(0).visible:
			set_visible(!get_tree().paused)
			get_tree().paused = !get_tree().paused
	if event.is_action_pressed("fullscreen"):
		_on_Fullscreen_pressed()

func _on_Button_pressed():
	get_tree().paused = false
	set_visible(false)

func set_visible(is_visable):
	for node in get_children():
		node.visible = is_visable

func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_Quit_pressed():
	get_tree().quit()
