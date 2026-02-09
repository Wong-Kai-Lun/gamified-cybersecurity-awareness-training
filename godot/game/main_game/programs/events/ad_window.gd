extends BaseWindow
class_name AdWindow

@export var possible_textures: Array[Texture2D]
@export var possible_sizes: Array[Vector2]
@onready var ad_texture_rect: TextureRect = $WindowPanel/Structure/Content/AdTextureRect

func _ready() -> void:
	super._ready()


func setup() -> void:
	ad_texture_rect.texture = possible_textures.pick_random()
	ad_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ad_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	custom_minimum_size = possible_sizes.pick_random()


func on_close_requested() -> void:
	queue_free()
