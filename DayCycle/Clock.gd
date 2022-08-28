extends Node

const DateTime = preload("./DateAndTime.gd")

signal time_passed(date_times)

export(int) var starting_year = 1
export(int, 1, 365) var starting_day = 0
export(int, 0, 23) var starting_hour = 6
export(float) var time_multiplier:int = 60 * 60 * 1

var time:float = (60 * 60 * 24 * 365 * starting_year) + (starting_day * 60 * 60 * 24) + (60 * 60 * starting_hour)

var dateTime:DateTime = DateTime.new(time)

func _process(delta):
	time += delta * time_multiplier
	dateTime = DateTime.new(time)
	emit_signal("time_passed", delta * time_multiplier)
#	dateTime.print_string()
