extends Node
class_name EventService

signal severity_changed(level: Severity)
signal adware_triggered(adware_count: int)
signal bsod_triggered
signal ransomware_found

enum Severity { NONE, MINOR, MODERATE, SIGNIFICANT, EXTREME }

const SEVERITY_THRESHOLDS = {
	Severity.NONE: 0,
	Severity.MINOR: 3,
	Severity.MODERATE: 6,
	Severity.SIGNIFICANT: 9,
	Severity.EXTREME: 12
}

var severity_level: Severity = Severity.NONE
var malware_count: int = 0
var adware_count: int = 0
var adware_timer: Timer
var total_malware_count: int = 0


func _ready() -> void:
	print("EventService online!")
	
	adware_timer = Timer.new()
	adware_timer.one_shot = true
	adware_timer.timeout.connect(_on_adware_timer_timeout)
	add_child(adware_timer)


func check_inventory() -> void:
	var player_inventory = GameManagerInstance.get_player_inventory()
	_calculate_malware(player_inventory)
	
	var new_severity = _calculate_severity(total_malware_count)
	if new_severity != severity_level:
		severity_level = new_severity
		_on_severity_changed(severity_level)
	
	if adware_count > 0 and adware_timer.is_stopped():
		_start_adware_timer()
	elif adware_count == 0:
		adware_timer.stop()
	
	# print("EventService | Malware Count: ", malware_count)
	# print("EventService | Severity Level: ", severity_level)


func _calculate_malware(inventory_array: Array[FileData]) -> void:
	malware_count = 0
	adware_count = 0
	
	for file in inventory_array:
		if file.file_type == FileData.FileType.MALWARE:
			malware_count += 1
			
		if file.file_type == FileData.FileType.ADWARE:
			adware_count += 1
	
	total_malware_count = malware_count + adware_count


func _calculate_severity(count: int) -> Severity:
	if count >= SEVERITY_THRESHOLDS[Severity.EXTREME]:
		bsod_triggered.emit()
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
			return 3.5
		Severity.EXTREME:
			return 5.0
		_:
			return 0.0


# Adware Related
func _start_adware_timer() -> void:
	var delay := randf_range(30.0, 45.0)
	adware_timer.start(delay)


func _on_adware_timer_timeout() -> void:
	if adware_count > 0:
		adware_triggered.emit(adware_count)
		_start_adware_timer()
