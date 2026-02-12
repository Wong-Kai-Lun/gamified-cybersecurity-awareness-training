extends Control
class_name NotificationToast

signal request_close(notif)

@onready var notification_title: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/NotificationTitle
@onready var notification_body: Label = $HBoxContainer/MarginContainer/VBoxContainer/NotificationBody
@onready var notification_color: ColorRect = $HBoxContainer/ColorRect
@onready var close_button: Button = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/CloseNotification


func setup(data) -> void:
	_set_notification_colour(data["type"])
	notification_title.text = data["title"]
	notification_body.text = data["body"]


func _set_notification_colour(type: NotificationManagerInstance.NotificationType) -> void:
	match type:
		NotificationManagerInstance.NotificationType.NEUTRAL:
			notification_color.color = Color("#AAAAAA")
			
		NotificationManagerInstance.NotificationType.ALERT:
			notification_color.color = Color("#FFFF00")
			
		NotificationManagerInstance.NotificationType.WARNING:
			notification_color.color = Color("#FF0000")


func _on_close_notification_pressed() -> void:
	request_close.emit(self)


func _on_timer_timeout() -> void:
	request_close.emit(self)
