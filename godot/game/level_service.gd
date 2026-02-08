extends Node
class_name LevelService

signal level_updated(level: Dictionary)

enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY }

const LEVELS = {
	Day.MONDAY: {
		"name" : "Monday",
		"email_pack" : preload("res://data/email_pack/monday.tres")
	},
	Day.TUESDAY: {
		"name" : "Tuesday",
		# "email_pack" : preload("res://data/email_pack/tuesday.tres")
	},
	Day.WEDNESDAY: {
		"name" : "Wednesday",
		# "email_pack" : preload("res://data/email_pack/wednesday.tres")
	}
}

var current_day: Day = Day.MONDAY


func _ready() -> void:
	print("LevelService online!")
	initialise()

func advance_day() -> void:
	current_day += 1
	#level_updated.emit(current_day)


func initialise() -> void:
	current_day = Day.MONDAY
	#change current_day if save file exists
	level_updated.emit(LEVELS[current_day])
	print(LEVELS[current_day])
