extends Node
class_name NotificationManager

signal request_notification(data)

func _ready() -> void:
	GameManagerInstance.inventory_full.connect(_notify_inventory_full)

func register_file(file: File) -> void:
	file.file_downloaded.connect(_notify_file_downloaded)

func _notify_file_downloaded(file_data: FileData) -> void:
	request_notification.emit({ "title": "File Downloaded", "body": file_data.file_name })
	AntivirusManagerInstance.scan_player_inventory()

func _notify_inventory_full() -> void:
	request_notification.emit({ "title": "No more space", "body": "Please remove some files." })
