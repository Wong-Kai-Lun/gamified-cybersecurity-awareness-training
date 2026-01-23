extends Resource
class_name EmailData

enum EmailType { MESSAGE, INBOUND, OUTBOUND }

@export var email_type: EmailType = EmailType.MESSAGE
@export var sender_name: String
@export var sender_address: String
@export var to_address: String
@export var cc_address: String
@export var subject: String
@export var email_body: String
@export var attached_files: Array[FileData] = []
@export var score: float
