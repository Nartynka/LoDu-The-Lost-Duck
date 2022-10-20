extends StaticBody2D

var active = false
export(String) var character_name = "NPC"
export(String) var default_dialog = ""
var quest_list = []

func _ready():
	for child in get_children():
		if child.is_in_group("quest"):
			quest_list.append(child)
#		var regex = RegEx.new()
#		# Match node name that starts with "Quest" and ends with 0 or more number
#		# e.g. "Quest", "Quest4", "Quest20" 
#		regex.compile("^(Quest)\\d*$")
#		if regex.search(child.name):
#			print(quest_list)
#			quest_list.append(child)


func _input(event):
	if event.is_action_pressed("action") and active:
		if quest_list:
			var quest = quest_list[0]
			quest.start_quest()
		elif default_dialog:
			DialogManager.start(default_dialog)


func _on_TriggerArea_body_entered(body):
	if body.name == "Player":
		active = true

func _on_TriggerArea_body_exited(body):
	if body.name == "Player":
		active = false
