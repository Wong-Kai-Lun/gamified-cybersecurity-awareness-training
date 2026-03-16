extends PanelContainer

@onready var correct_files_count: Label = $VBoxContainer/MarginContainer/GridContainer/CFCount
@onready var correct_reports_count: Label = $VBoxContainer/MarginContainer/GridContainer/CRCount


func _ready() -> void:
	pass # Replace with function body.


func _wait(duration: float) -> void:
	await get_tree().create_timer(duration).timeout


func _animate_score_calc():
	pass
