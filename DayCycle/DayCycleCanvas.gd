extends CanvasModulate

func _ready():
	DayCycle.connect("color_changed", self, "_on_color_changed")

func _on_color_changed(new_color):
	color = new_color
