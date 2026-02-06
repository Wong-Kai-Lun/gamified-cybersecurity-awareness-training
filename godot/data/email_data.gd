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

@export var inbound_attachments: Array[FileData] = []
@export var expected_attachments: Array[FileData] = []

@export var is_read: bool = false
@export var is_important: bool = false
@export var is_phishing: bool = false
@export var is_reported: bool = false

@export var score: float
