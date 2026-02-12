extends Node
class_name EventService

signal severity_changed(level: Severity)
signal adware_triggered(adwindow_amount: int)
signal malware_cloned
signal game_over(reason: GameOverReason)

enum Severity { NONE, MINOR, MODERATE, SIGNIFICANT, EXTREME }
enum GameOverReason { OVERLOAD, RANSOMWARE }

const SEVERITY_THRESHOLDS = {
	Severity.NONE: 0,
	Severity.MINOR: 3,
	Severity.MODERATE: 6,
	Severity.SIGNIFICANT: 9,
	Severity.EXTREME: 12
}

var severity_level: Severity = Severity.NONE

var malware_count: int = 0
var malware_timer: Timer

var adware_count: int = 0
var base_ad_window_amount: int = 3
var adware_timer: Timer

var total_malware_count: int = 0


func _ready() -> void:
	print("EventService online!")
	
	adware_timer = Timer.new()
	adware_timer.one_shot = true
	adware_timer.timeout.connect(_on_adware_timer_timeout)
	add_child(adware_timer)
	
	malware_timer = Timer.new()
	malware_timer.one_shot = false
	malware_timer.timeout.connect(_on_malware_timer_timeout)
	add_child(malware_timer)


func check_inventory() -> void:
	var player_inventory := GameManagerInstance.get_player_inventory()
	_calculate_malware(player_inventory)
	_calculate_adware(player_inventory)
	_calculate_total_malware()
	
	var new_severity = _calculate_severity(total_malware_count)
	if new_severity != severity_level:
		severity_level = new_severity
		_on_severity_changed(severity_level)
	
	if adware_count > 0 and adware_timer.is_stopped():
		_start_adware_timer()
	elif adware_count == 0:
		adware_timer.stop()
	
	if malware_count > 0 and malware_timer.is_stopped():
		_start_malware_timer()
	elif malware_count == 0:
		malware_timer.stop()


func _calculate_malware(inventory_array: Array[FileData]) -> void:
	malware_count = 0
	
	for file in inventory_array:
		if file.file_type == FileData.FileType.MALWARE:
			malware_count += 1


func _calculate_adware(inventory_array: Array[FileData]) -> void:
	adware_count = 0
	
	for file in inventory_array:
			
		if file.file_type == FileData.FileType.ADWARE:
			adware_count += 1


func _calculate_total_malware() -> void:
	total_malware_count = malware_count + adware_count


func _calculate_severity(count: int) -> Severity:
	if count >= SEVERITY_THRESHOLDS[Severity.EXTREME]:
		game_over.emit(GameOverReason.OVERLOAD)
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
	var delay := randf_range(30.0, 40.0)
	adware_timer.start(delay)

func _on_adware_timer_timeout() -> void:
	if adware_count > 0:
		adware_triggered.emit(base_ad_window_amount + adware_count)
		_start_adware_timer()


# Malware Related
func _start_malware_timer() -> void:
	var delay := randf_range(15.0, 20.0)
	malware_timer.start(delay)


func _on_malware_timer_timeout() -> void:
	var player_inventory := GameManagerInstance.get_player_inventory()
	var malware_files := player_inventory.filter( 
		func(a): return a.file_type == FileData.FileType.MALWARE )
	
	if malware_files.is_empty():
		return
	
	for malware in malware_files:
		_try_clone_malware(malware)


func _try_clone_malware(file: FileData) -> void:
	var roll := randf()
	
	if roll < file.clone_rate:
		FileServiceInstance.try_add_to_inventory(file)
		print("Malware Clone Success | ", "Roll: ", roll, " Clone Rate: ", file.clone_rate)
	else:
		print("Malware Clone Failed")
