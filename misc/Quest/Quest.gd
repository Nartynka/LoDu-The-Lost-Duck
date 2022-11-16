extends Node

"""
Instance this as a child of any Npc.tscn node and it turns into a quest giver.

The character will also check if the player has a certain amount of a given item and if true
Remove said amount from the players inventory and give some amount of another item as a reward
"""


export(String) var quest_name = "Test Quest"

export(Quest.TYPE) var quest_type = Quest.TYPE.COLLECT
export(String) var required_quest = ""

export(String) var required_thing = ""
export(int) var required_amount = 0
export(String) var reward_item = "Generic Reward"
export(int) var reward_amount = 1

export(String) var initial_dialog = "Test Quest"
export(String) var pending_dialog = "Test Quest Pending"
export(String) var delivered_dialog = "Test Quest Complete"

var quest_status = Quest.STATUS.NONEXISTENT

func start_quest():
	if required_quest:
		if Quest.get_status(required_quest) == Quest.STATUS.NONEXISTENT:
			print("You need to start '", required_quest, "' quest to start this quest")
			DialogManager.start("required_quest")
			if get_parent().default_dialog:
				DialogManager.start(get_parent().default_dialog)
			return
	var is_quest_new = Quest.accept_quest(quest_name)
	if is_quest_new:
		DialogManager.start(initial_dialog)
	process()

func process():
	quest_status = Quest.get_status(quest_name)
	print(Quest.STATUS.keys()[quest_status])
	match quest_status:
		Quest.STATUS.NONEXISTENT:
			start_quest()
		Quest.STATUS.ACTIVE:
			process_active()
			if Quest.get_status(quest_name) == Quest.STATUS.ACTIVE:
				DialogManager.start(pending_dialog)
		Quest.STATUS.COMPLETE:
			if quest_type == Quest.TYPE.COLLECT:
				PlayerInventory.remove_item(required_thing, required_amount)
			if reward_item != "":
				PlayerInventory.add_item(reward_item, reward_amount)
			print("complete dialog")
			DialogManager.start(delivered_dialog)
			get_parent().quest_list.pop_front()
		_:
			return

func process_active():
	match quest_type:
		Quest.TYPE.COLLECT:
			if PlayerInventory.get_item_count(required_thing) >= required_amount || required_thing == "":
				Quest.change_status(quest_name, Quest.STATUS.COMPLETE)
		Quest.TYPE.TALK:
			if Quest.talked_to.has(required_thing):
				Quest.change_status(quest_name, Quest.STATUS.COMPLETE)
		Quest.TYPE.REQUIRED:
			Quest.talked_to.push_front(required_thing)
			Quest.change_status(quest_name, Quest.STATUS.COMPLETE)
			print(Quest.talked_to)
