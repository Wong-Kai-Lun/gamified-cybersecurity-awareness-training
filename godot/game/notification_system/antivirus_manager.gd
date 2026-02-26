extends Node
class_name AntivirusManager

signal threat_found(file_name: String)
# signal list_changed

@onready var scan_timer: Timer = Timer.new()
var found_threats: Array[String] = []


func _ready() -> void:
	add_child(scan_timer)
	scan_timer.wait_time = 15.0
	scan_timer.one_shot = false
	scan_timer.timeout.connect(scan_player_inventory)
	scan_timer.start()


func scan_player_inventory() -> void:
	var player_inventory = FileServiceInstance.get_player_inventory()
	var has_malware = false
	var caught_file = ""
	
	for file in player_inventory:
		if file.file_type != FileData.FileType.LEGIT:
			has_malware = true
			caught_file = file.file_name
	
	if has_malware:
		threat_found.emit(caught_file)
