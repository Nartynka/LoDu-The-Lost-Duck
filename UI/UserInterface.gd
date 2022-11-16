extends CanvasLayer
var holding_item = null

func _ready():
	Quest.connect("quest_changed", self, "_on_quest_changed")
	
func _on_quest_changed(name, status):
	print("aaaa",name, status)
	$QuestLabel.text = name+" ("+status+")"
