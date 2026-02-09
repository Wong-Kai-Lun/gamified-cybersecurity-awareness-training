extends BaseWindow
class_name AdWindow

@export var possible_textures: Array[Texture2D]
@onready var ad_texture_rect: TextureRect = $WindowPanel/Structure/Content/AdTextureRect

func _ready() -> void:
	super._ready()
	setup()
	

func setup() -> void:
	ad_texture_rect.texture = possible_textures.pick_random()
