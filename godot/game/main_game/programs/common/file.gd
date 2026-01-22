@tool
extends Control
class_name File

var file_id: String = ""
var _file_img: Texture2D = null
var _file_name: String = ""

@onready var img_texture_rect: TextureRect = $MarginContainer/VBoxContainer/AspectRatioContainer/FileImg
@onready var name_label: Label = $MarginContainer/VBoxContainer/FileName

@export var file_img: Texture2D:
	set(value):
		_file_img = value
		if img_texture_rect:
			img_texture_rect.texture = value
	get:
		return _file_img

@export var file_name: String:
	set(value):
		_file_name = value
		if name_label:
			name_label.text = value
	get:
		return _file_name
		
@export var is_draggable: bool = false

func _ready() -> void:
	if img_texture_rect:
		img_texture_rect.texture = _file_img
	
	if name_label:
		name_label.text = _file_name


# GUI
# func setup() -> void:
# create FileData.gd first


func _get_drag_data(at_position: Vector2) -> Variant:
	if is_draggable:
		var preview_texture = TextureRect.new()
		preview_texture.texture = _file_img
		preview_texture.expand = true
		preview_texture.custom_minimum_size = Vector2(80, 80)
		
		var preview_text_label = Label.new()
		preview_text_label.text = _file_name
		preview_text_label.add_theme_color_override("font_color", Color("#000000"))
		
		var preview_container = VBoxContainer.new()
		var aspect_ratio_container = AspectRatioContainer.new()
		aspect_ratio_container.add_child(preview_texture)
		preview_container.add_child(aspect_ratio_container)
		preview_container.add_child(preview_text_label)
		
		set_drag_preview(preview_container)
		
		return {
			"id": file_id,
			"name": _file_name,
			"icon": _file_img,
			"source": self
		}
	return
