extends Node
class_name EventService

signal severity_changed(level: Severity)
signal adware_triggered(adwindow_amount: int)
signal malware_cloned
signal game_over(reason: GameOverReason)
signal ransomware_downloaded

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
var adware_count: int = 0
var ransomware_present: bool = false
var total_threat_count: int = 0

var malware_timer: Timer
var adware_timer: Timer
var ransomware_timer: Timer

const base_ad_window_amount: int = 3


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
	
	ransomware_timer = Timer.new()
	ransomware_timer.one_shot = true
	ransomware_timer.timeout.connect(_on_ransomware_timer_timeout)
	add_child(ransomware_timer)
	
	GameManagerInstance.inventory_changed.connect(_on_inventory_changed)

# Main
func _on_inventory_changed(player_inventory: Array[FileData]) -> void:
	_analyse_threats(player_inventory)
	
	var new_severity = _calculate_severity(total_threat_count)
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
	
	if ransomware_present and ransomware_timer.is_stopped():
		_start_ransomware_timer()
	elif not ransomware_present:
		ransomware_timer.stop()


func _analyse_threats(inventory: Array[FileData]) -> void:
	malware_count = 0
	adware_count = 0
	total_threat_count = 0
	
	for file in inventory:
		match file.file_type:
			FileData.FileType.MALWARE:
				malware_count += 1
			FileData.FileType.ADWARE:
				adware_count += 1
			FileData.FileType.RANSOMWARE:
				if not ransomware_present:
					ransomware_present = true
					ransomware_downloaded.emit()
	
	total_threat_count = malware_count + adware_count


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


# Adware
func _start_adware_timer() -> void:
	var delay := randf_range(20.0, 25.0)
	adware_timer.start(delay)

func _on_adware_timer_timeout() -> void:
	if adware_count > 0:
		adware_triggered.emit(base_ad_window_amount + adware_count)
		_start_adware_timer()


# Malware
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
		_try_malware_action(malware)


func _try_malware_action(malware_file: FileData) -> void:
	var roll := randf()
	
	if roll >= malware_file.trigger_rate:
		print("Malware Tick Failed | ", "Roll: ", roll, " Clone Rate: ", malware_file.trigger_rate)
		return
	
	if GameManagerInstance.is_inventory_full():
		GameManagerInstance.corrupt_random_inventory_file(malware_file)
		print("Inventory Full! File Corruption Attempted.")
		print("Malware Corruption Success | ", "Roll: ", roll, " Clone Rate: ", malware_file.trigger_rate)
	else:
		FileServiceInstance.try_add_to_inventory(malware_file)
		print("Inventory Not Full! File Cloning Attempted.")
		print("Malware Clone Success | ", "Roll: ", roll, " Clone Rate: ", malware_file.trigger_rate)

# Ransomware
func _start_ransomware_timer() -> void:
	var delay := 45.0
	ransomware_timer.start(delay)

func _on_ransomware_timer_timeout() -> void:
	game_over.emit(GameOverReason.RANSOMWARE)
