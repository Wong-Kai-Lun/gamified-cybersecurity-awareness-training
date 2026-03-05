extends Resource
class_name EmailData

signal outbound_updated(outbound_array: Array[FileData])

enum EmailType { MESSAGE, INBOUND, OUTBOUND }

@export var email_id: String
@export var email_type: EmailType = EmailType.MESSAGE
@export var sender_name: String
@export var sender_address: String
@export var to_address: String
@export var cc_address: String
@export var subject: String
@export var email_body: String

@export var inbound_attachments: Array[FileData] = []
@export var expected_attachments: Array[FileData] = []
var outbound_attachments: Array[FileData] = []

@export var score: float

@export var is_important: bool = false
@export var is_phishing: bool = false

var flags := {
	"read": false,
	"reported": false,
	"sent": false
}


func append_file_to_outbound(file_data: FileData):
	outbound_attachments.append(file_data)
	outbound_updated.emit(outbound_attachments.duplicate(true))


func remove_file_from_outbound(file_data: FileData):
	outbound_attachments.erase(file_data)
	outbound_updated.emit(outbound_attachments.duplicate(true))


func get_save_data() -> Dictionary:
	return {
		"id": email_id,
		"flags": flags
	}
