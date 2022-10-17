tool
extends EditorPlugin

var _dock 
var _itemList
var _text_editor
var _label_info
var _saving_timer
var _typing_timer

var _current_file = ""
var _current_item_index = 0
var _dialog_opened_for = ""
var _user_prefs
var _keywords 
var _last_lines = {}

func _enter_tree():
	# SET REFERENCES TO NODES
	_dock = preload("res://addons/json_editor/json_editor.tscn").instance()
	_itemList = _dock.get_node("v_split/container/h_split/sections_area/panel/item_list")
	_text_editor = _dock.get_node("v_split/container/h_split/text_area/text_edit")
	_label_info = _dock.get_node("v_split/container_titolo/label_info")
	_saving_timer = _dock.get_node("saving_timer")
	_typing_timer = _dock.get_node("typing_timer")

	# ADD THE ADDON TO THE BOTTON PANEL
	add_control_to_bottom_panel(_dock, "Json Editor")
	
	# CONNECT SIGNALS TO EVENTS
	var update_button = _dock.get_node("v_split/container_titolo/update_button")
	update_button.connect("pressed", self, "update_folder")
	
	_itemList.connect("item_selected", self, "load_file")
	
	var save_button = _dock.get_node("v_split/container_titolo/save_button")
	save_button.connect("pressed", self, "save_file")
	
	_text_editor.connect("text_changed", self, "editor_text_changed")

	var add_btn = _dock.get_node("v_split/container/h_split/sections_area/tools/add_button")
	add_btn.connect("pressed", self, "open_new_file_dlg")
	
	var rename_btn = _dock.get_node("v_split/container/h_split/sections_area/tools/rename_button")
	rename_btn.connect("pressed", self, "open_rename_file_dlg")
	
	var delete_btn = _dock.get_node("v_split/container/h_split/sections_area/tools/delete_button")
	delete_btn.connect("pressed", self, "open_delete_file_dlg")

	var nf_cancel = _dock.get_node("new_file_dialog/margin/vsplit_1/container/vsplit_2/hsplit_1/nf_cancel_button")
	nf_cancel.connect("pressed", self, "new_file_cancel")
	
	var nf_ok = _dock.get_node("new_file_dialog/margin/vsplit_1/container/vsplit_2/hsplit_1/nf_ok_button")
	nf_ok.connect("pressed", self, "new_file_ok")
	
	var del_cancel = _dock.get_node("del_file_dialog/margin/vsplit_1/container/hsplit_1/del_cancel")
	del_cancel.connect("pressed", self, "del_file_dialog_cancel")
	
	var del_ok = _dock.get_node("del_file_dialog/margin/vsplit_1/container/hsplit_1/del_ok")
	del_ok.connect("pressed", self, "del_file_dialog_ok")
	
	var save_timer = _dock.get_node("saving_timer")
	save_timer.connect("timeout", self, "autosave_file")
	
	# LOAD USER PREFERENCES
	load_prefereces()
	
	# SET THE AUTOSAVE TIMER TIMEOUT
	_saving_timer.wait_time = float(_user_prefs["autosave_timer"])
	
	# LOAD AND SET KEYWORDS HIGHLIGHT COLORS
	load_keywords()
	for key in _keywords:
		_text_editor.add_keyword_color(key, Color(_keywords[key]))

	# LOAD THE LAST LINES DICTONARY (LAST POSITION OF CURSOR FOR EVERY FILE OPENED)
	load_last_lines()
	
	
	# LOAD THE FILE LIST FROM CONTENT FOLDER 
	var file_folder = _dock.get_node("v_split/container_titolo/file_folder")
	file_folder.text = _user_prefs["content_folder"]
	load_file_list()


# SAVE THE LAST LINES DICTONARY WHEN USER EXIT FROM GODOT
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_last_lines()

# SAVE LAST LINES DICTONARY
func save_last_lines():
	var file_name = "res://addons/json_editor/config/files_last_lines.json"
	var last_f = File.new()
	if not last_f.file_exists(file_name):
		return
	last_f.open(file_name, File.WRITE)
	last_f.store_line(to_json(_last_lines))
	last_f.close()
	
# LOAD LAST LINES DICTONARY
func load_last_lines():
	var file_name = "res://addons/json_editor/config/files_last_lines.json"
	var last_f = File.new()
	if not last_f.file_exists(file_name):
		return
	last_f.open(file_name, File.READ)
	_last_lines = parse_json(last_f.get_as_text())
	last_f.close()

# SHOW THE CHANGES IN THE TEXT (ADD SUFFIX * ON FILE NAME)
func editor_text_changed():
	if not _label_info.text.ends_with("*"):
		_label_info.text = _label_info.text.trim_suffix(" *")
		_label_info.text = _label_info.text + " *"
	
	# reset timer, so it doesn't save until user is writing
	if _user_prefs["autosave"] == "on":
		_saving_timer.start()

# AUTOSAVE THE CURRENT FILE
func autosave_file():
	if _user_prefs["autosave"] == "on":
		if _label_info.text.ends_with("*"):
			save_file()

# LOAD ADDON PREFERENCES
func load_prefereces():
	var file_name = "res://addons/json_editor/config/user_preferences.json"
	var prefs = File.new()
	if not prefs.file_exists(file_name):
		return
	prefs.open(file_name, File.READ)
	_user_prefs = parse_json(prefs.get_as_text())
	prefs.close()

# LOAD KEYWORDS COLOR
func load_keywords():
	var file_name = "res://addons/json_editor/config/keywords.json"
	var keywrd = File.new()
	if not keywrd.file_exists(file_name):
		return
	keywrd.open(file_name, File.READ)
	_keywords = parse_json(keywrd.get_as_text())
	keywrd.close()


# SAVE THE FOLDER PATH AND UPDATE THE FILE LIST
func update_folder():
	var file_folder = _dock.get_node("v_split/container_titolo/file_folder")
	#folder path sould not contains / at the end, so check it and remove it
	if file_folder.text != "res://":
		file_folder.text = file_folder.text.rstrip("/")
	_user_prefs["content_folder"] = file_folder.text
	save_preferences()
	load_file_list()


# SAVE ADDON PREFERENCES
func save_preferences():
	var file_name = "res://addons/json_editor/config/user_preferences.json"
	var prefs = File.new()
	if not prefs.file_exists(file_name):
		return
	prefs.open(file_name, File.WRITE)
	prefs.store_line(to_json(_user_prefs))
	prefs.close()



# SHOW ALL FILES IN FOLDER
func load_file_list():
	_itemList.clear()
	
	# search all files in folder
	var dir = Directory.new()
	dir.open(_user_prefs["content_folder"])
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			# adds only files with extension in user preferences
			var file_extension = file.get_extension()
			if file_extension in _user_prefs["file_format"]:
				_itemList.add_item(file)
	dir.list_dir_end()
	
	# search and load the last opened file
	_text_editor.text = ""
	if _user_prefs["last_opened_file"] != "":
		for i in range(0, _itemList.get_item_count()):
			if _user_prefs["last_opened_file"] == _itemList.get_item_text(i):
				_itemList.select(i)
				load_file(i)


# LOAD THE FILE AND SHOW THE CONTENT ON TEXT EDITOR
func load_file(index):
	# params
	# index		Int: file list index to load 
	
	# save the cursor position of the current file (if exist) befor load the new selected
	if _current_file != "":
		_last_lines[_current_file] = _text_editor.cursor_get_line()
	
	_current_item_index = index
	_current_file = _itemList.get_item_text(index)

	var file_to_load = File.new()
	if not file_to_load.file_exists(_user_prefs["content_folder"] + "/" + _current_file):
		return 
	file_to_load.open(_user_prefs["content_folder"] + "/" +  _current_file, File.READ)

	_text_editor.text = file_to_load.get_as_text()
	file_to_load.close()
	
	# enable/disable keywords 
	var file_extension = _current_file.get_extension()
	if file_extension in _user_prefs["keyword_enabled_for"]:
		_text_editor.set_syntax_coloring(true)
	else:
		_text_editor.set_syntax_coloring(false)
	
	# show the file's name
	_label_info.text = _current_file
	
	# save the opened file in preferences
	_user_prefs["last_opened_file"] = _current_file
	save_preferences()

	# read and set the last cursor position from the dictonary 
	if _last_lines.has(_current_file):
		_text_editor.cursor_set_line(_last_lines[_current_file])


# SAVE THE TEXT TO FILE
func save_file():
	var file_to_save = File.new()
	file_to_save.open(_user_prefs["content_folder"] + "/" +  _current_file, File.WRITE)
	file_to_save.store_line(_text_editor.text)
	file_to_save.close()
	_label_info.text = _label_info.text.trim_suffix(" *")
	
	# add/set the current cursor position to the dictonary
	_last_lines[_current_file] = _text_editor.cursor_get_line()


# OPEN THE DIALOG PANEL TO CREATE A NEW FILE
func open_new_file_dlg():
	_dialog_opened_for = "new_file"
	_dock.get_node("new_file_dialog").window_title = "Add New File"
	_dock.get_node("new_file_dialog/margin/vsplit_1/container/vsplit_2/file_name").text = ""
	_dock.get_node("new_file_dialog").show_modal(true)
	_dock.get_node("new_file_dialog/margin/vsplit_1/container/vsplit_2/file_name").grab_focus()
	
# OPEN THE DIALOG PANEL FOR RENAME THE SELECTED FILE
func open_rename_file_dlg():
	_dialog_opened_for = "rename_file"
	_dock.get_node("new_file_dialog").window_title = "Rename File"
	_dock.get_node("new_file_dialog/margin/vsplit_1/container/vsplit_2/file_name").text = _current_file
	_dock.get_node("new_file_dialog").show_modal(true)
	_dock.get_node("new_file_dialog/margin/vsplit_1/container/vsplit_2/file_name").grab_focus()

# CLOSE THE "NEW FILE" DIALOG PANEL
func new_file_cancel():
	_dock.get_node("new_file_dialog/margin/vsplit_1/container/vsplit_2/file_name").text = ""
	_dock.get_node("new_file_dialog").hide()
	
# OPEN THE "DELETE FILE" DIALOG PANEL
func open_delete_file_dlg():
	_dock.get_node("del_file_dialog").show_modal(true)

# CLOSE THE "DELETE FILE" DIALOG PANEL
func del_file_dialog_cancel():
	_dock.get_node("del_file_dialog").hide()


# CREATE A NEW FILE OR RENAME THE SELECTED ONE
func new_file_ok():
	var file_name = _dock.get_node("new_file_dialog/margin/vsplit_1/container/vsplit_2/file_name").text
	if file_name.is_valid_filename():
		# create a new file...
		if _dialog_opened_for == "new_file":
			var empty_file = File.new()
			empty_file.open(_user_prefs["content_folder"] + "/" + file_name, File.WRITE)
			empty_file.store_line("")
			empty_file.close()
			
			# update the list
			load_file_list()
		
		# ...or rename it
		if _dialog_opened_for == "rename_file":
			#rename the file
			var dir = Directory.new()
			dir.rename(_user_prefs["content_folder"] + "/" + _current_file, _user_prefs["content_folder"] + "/" + file_name)
			
			# update the list
			load_file_list()
			_itemList.select(_current_item_index)
			
		# close dialog
		new_file_cancel()
	

# DELETE THE CURRENT SELECTED FILE
func del_file_dialog_ok():
	_dock.get_node("del_file_dialog").hide()
	
	# delete file...
	var dir = Directory.new()
	dir.remove(_user_prefs["content_folder"] + "/" + _current_file)
	
	# ...and update the list
	load_file_list()
	
	_user_prefs["last_opened_file"] = ""
	save_preferences()
	
# REMOVE THE ADDON FROM THE BOTTOM PANEL
func _exit_tree():
	remove_control_from_bottom_panel(_dock)
	_dock.free() 
