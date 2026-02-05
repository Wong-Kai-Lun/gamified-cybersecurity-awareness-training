extends Control
class_name File

signal remove_requested(file_data: FileData)
signal file_downloaded(file_data: FileData)

@onready var action_menu_button: MenuButton = $ActionMenuButton
@onready var img_texture_rect: TextureRect = $ActionMenuButton/MarginContainer/VBoxContainer/AspectRatioContainer/FileImg
@onready var name_label: Label = $ActionMenuButton/MarginContainer/VBoxContainer/FileName
var file_data: FileData
var is_draggable: bool = true


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	name_label.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _on_mouse_exited() -> void:
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.autowrap_mode = TextServer.AUTOWRAP_OFF


func setup(data: FileData) -> void:
	file_data = data
	img_texture_rect.texture = data.file_texture
	name_label.text = data.file_name
	self.tooltip_text = data.file_name
	
	match data.file_context:
		FileData.FileContext.INBOUND:
			_setup_inbound_file()
			action_menu_button.flat = true
			action_menu_button.button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT
		
		FileData.FileContext.INVENTORY:
			_setup_inventory_file()
			action_menu_button.flat = false
			
		FileData.FileContext.OUTBOUND:
			_setup_outbound_file()
			action_menu_button.flat = true
			action_menu_button.button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT
			
		FileData.FileContext.TRASH:
			_setup_deleted_file()
			action_menu_button.flat = true
			
		_:
			push_warning("Unknown FileContext: %s" % data.context)


# Abstract later.
func _setup_inbound_file() -> void:
	is_draggable = false
	
	NotificationManagerInstance.register_file(self)
	
	var action_menu_popup: PopupMenu = action_menu_button.get_popup()
	action_menu_popup.add_item("Download", 0)
	action_menu_popup.id_pressed.connect(_file_action)


func _setup_inventory_file() -> void:
	is_draggable = true
	
	var action_menu_popup: PopupMenu = action_menu_button.get_popup()
	action_menu_popup.add_item("Delete", 1)
	action_menu_popup.id_pressed.connect(_file_action)


func _setup_outbound_file() -> void:
	is_draggable = false
	
	var action_menu_popup: PopupMenu = action_menu_button.get_popup()
	action_menu_popup.add_item("Remove Attachment", 2)
	action_menu_popup.id_pressed.connect(_file_action)


func _setup_deleted_file() -> void:
	is_draggable = false
	
	var action_menu_popup: PopupMenu = action_menu_button.get_popup()
	action_menu_popup.add_item("Restore", 3)
	action_menu_popup.id_pressed.connect(_file_action)


# Action Menu Logic
func _file_action(id: int) -> void:
	match id:
		0:
			var success := FileServiceInstance.try_add_to_inventory(file_data)
			if success:
				file_downloaded.emit(file_data)
		
		1:
			print("Delete pressed!")
			FileServiceInstance.move_inventory_to_trash(file_data)
			_on_delete_requested()
			
		2:
			print("Remove Attachment pressed!")
			_on_remove_requested()
			
		3:
			print("File Restored!")
			FileServiceInstance.move_trash_to_inventory(file_data)
			_on_delete_requested()

func _on_remove_requested() -> void:
	remove_requested.emit(file_data)
	queue_free()

# turn into common
func _on_delete_requested() -> void:
	queue_free()


func _get_drag_data(at_position: Vector2) -> FileData:
	if is_draggable:
		set_drag_preview(_build_drag_preview())
		return file_data
	return


func _build_drag_preview() -> VBoxContainer:
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
	
	return preview_container
