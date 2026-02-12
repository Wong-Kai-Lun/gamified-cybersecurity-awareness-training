extends Resource
class_name FileData

enum FileContext { INBOUND, INVENTORY, OUTBOUND, TRASH }
enum FileType { LEGIT, MALWARE, ADWARE, RANSOMWARE }

@export var file_id: String
@export var file_texture: Texture2D
@export var file_name: String
@export var file_context: FileContext = FileContext.INBOUND
@export var file_type: FileType = FileType.LEGIT 
@export var trigger_rate: float = 0.0
