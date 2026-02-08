extends Node
class_name EventService

signal severity_changed(level: Severity)
signal ransomware_found

enum Severity { NONE, MINOR, MODERATE, SIGNIFICANT, EXTREME }

const SEVERITY_THRESHOLDS = {
	Severity.NONE: 0,
	Severity.MINOR: 1,
	Severity.MODERATE: 4,
	Severity.SIGNIFICANT: 7,
	Severity.EXTREME: 10
}

var malware_count = 0
var severity_level: Severity = Severity.NONE


func _ready() -> void:
	print("EventService online!")


func check_inventory() -> void:
	var player_inventory = GameManagerInstance.get_player_inventory()
	_calculate_malware(player_inventory)
	
	var new_severity = _calculate_severity(malware_count)
	if new_severity != severity_level:
		severity_level = new_severity
		_on_severity_changed(severity_level)
	
	print("EventService | Malware Count: ", malware_count)
	print("EventService | Severity Level: ", severity_level)


func _calculate_malware(inventory_array: Array[FileData]) -> void:
	malware_count = 0
	
	for file in inventory_array:
		if file.file_type == FileData.FileType.MALWARE:
			malware_count += 1


func _calculate_severity(count: int) -> Severity:
	if count >= SEVERITY_THRESHOLDS[Severity.EXTREME]:
		return Severity.EXTREME
	elif count >= SEVERITY_THRESHOLDS[Severity.SIGNIFICANT]:
		return Severity.SIGNIFICANT
	elif count >= SEVERITY_THRESHOLDS[Severity.MODERATE]:
		return Severity.MODERATE
	elif count >= SEVERITY_THRESHOLDS[Severity.MINOR]:
		return Severity.MINOR
	return Severity.NONE


func _on_severity_changed(level: Severity) -> void:
	severity_changed.emit(level)


# Input Delay
func delay_input() -> void:
	var delay = _get_delay_seconds()
	if delay <= 0.0:
		return
		
	await get_tree().create_timer(delay).timeout


func _get_delay_seconds() -> float:
	match severity_level:
		Severity.MINOR:
			return 1.0
		Severity.MODERATE:
			return 2.0
		Severity.SIGNIFICANT:
			return 4.0
		Severity.EXTREME:
			return 6.0
		_:
			return 0.0
