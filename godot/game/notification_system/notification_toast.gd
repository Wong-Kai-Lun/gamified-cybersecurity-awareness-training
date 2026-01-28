extends Control
class_name NotificationToast

signal request_close(notif)

@onready var notification_title: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NotificationTitle
@onready var notification_body: Label = $PanelContainer/MarginContainer/VBoxContainer/NotificationBody


func setup(data) -> void:
	notification_title.text = data["title"]
	notification_body.text = data["body"]


func _on_close_notification_pressed() -> void:
	request_close.emit(self)


func _on_timer_timeout() -> void:
	request_close.emit(self)
