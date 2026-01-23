extends Control
class_name File

@onready var action_menu_button: MenuButton = $ActionMenuButton
@onready var img_texture_rect: TextureRect = $ActionMenuButton/MarginContainer/VBoxContainer/AspectRatioContainer/FileImg
@onready var name_label: Label = $ActionMenuButton/MarginContainer/VBoxContainer/FileName
var file_data: FileData
var is_draggable: bool = true

func setup(data: FileData) -> void:
	file_data = data
	
	img_texture_rect.texture = data.file_texture
	name_label.text = data.file_name
	
	match data.file_context:
		FileData.FileContext.INBOUND:
			print("File Context is INBOUND!")
		
		FileData.FileContext.INVENTORY:
			print("File Context is INVENTORY!")
			
		FileData.FileContext.TRASH:
			print("File Context is TRASH!")

# setup actions menu button later

func _get_drag_data(at_position: Vector2) -> Variant:
	if is_draggable:
		var preview_texture = TextureRect.new()
		preview_texture.texture = file_data.file_texture
		preview_texture.expand = true
		preview_texture.custom_minimum_size = Vector2(80, 80)
		
		var preview_text_label = Label.new()
		preview_text_label.text = file_data.file_name
		preview_text_label.add_theme_color_override("font_color", Color("#000000"))
		
		var preview_container = VBoxContainer.new()
		var aspect_ratio_container = AspectRatioContainer.new()
		aspect_ratio_container.add_child(preview_texture)
		preview_container.add_child(aspect_ratio_container)
		preview_container.add_child(preview_text_label)
		
		set_drag_preview(preview_container)
		
		return {
			"Test": "Hello World"
			# "name": _file_name,
			# "icon": _file_img,
			# "source": self
		}
	return
