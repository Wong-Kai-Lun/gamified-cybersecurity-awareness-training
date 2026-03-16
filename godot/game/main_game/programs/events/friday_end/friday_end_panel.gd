extends PanelContainer

@onready var correct_files_count: Label = $VBoxContainer/MarginContainer/GridContainer/CFCount
@onready var correct_reports_count: Label = $VBoxContainer/MarginContainer/GridContainer/CRCount
@onready var final_cf_label: Label = $VBoxContainer/MarginContainer2/GridContainer/FSCalcCF
@onready var final_cr_label: Label = $VBoxContainer/MarginContainer2/GridContainer/FSCR
@onready var final_score: Label = $VBoxContainer/MarginContainer2/GridContainer/FinalScore


func _ready() -> void:
	_animate_score_calc()


func _wait(duration: float) -> void:
	await get_tree().create_timer(duration).timeout


func _animate_score_calc():
	# calculate score in levelmanager
	await _wait(2.0)
	correct_files_count.text = str(LevelServiceInstance.getCorrectFiles())
	await _wait(1.0)
	correct_reports_count.text = str(LevelServiceInstance.getCorrectReports())
	await _wait(1.0)
	final_cf_label.text = str(LevelServiceInstance.calcCorrectFilesScore())
	await _wait(1.0)
	final_cr_label.text = str(LevelServiceInstance.getCorrectReports())
	await _wait(1.0)
	final_score.text = str(LevelServiceInstance.calcFinalScore())


func _on_to_menu_pressed() -> void:
	GameManagerInstance.stop_game()
