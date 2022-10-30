extends Control

onready var sprite = $Sprite
onready var dayLabel = $DayLabel
onready var timeLabel = $TimeLabel

func _ready():
	DayCycle.connect("time_of_day_change", self, "_on_time_of_day_change")

func _process(delta):
	dayLabel.text = Clock.get_day_string()
	timeLabel.text = Clock.get_time_string()
	
func _on_time_of_day_change(frame):
	sprite.frame = frame
