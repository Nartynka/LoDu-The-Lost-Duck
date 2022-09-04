extends Node

const DateTime = preload("./DateAndTime.gd")

signal time_passed

export(int) var starting_year = 1
export(int, 1, 365) var starting_day = 0
export(int, 0, 23) var starting_hour = 12
export(float) var time_multiplier:int = 60 * 60

var time:float = (60 * 60 * 24 * 365 * starting_year) + (starting_day * 60 * 60 * 24) + (60 * 60 * starting_hour)

var dateTime:DateTime = DateTime.new(time)

func _process(delta):
	time += delta * time_multiplier 
	dateTime = DateTime.new(time)
	emit_signal("time_passed")

func get_time_string() -> String:
	return dateTime.get_time_string(false)

func get_day_string() -> String:
	return "Day "+str(dateTime.day)
