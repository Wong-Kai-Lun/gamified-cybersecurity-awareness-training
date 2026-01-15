extends Resource
class_name EmailData

@export var email_type: String
@export var sender_name: String
@export var sender_address: String
@export var to_address: String
@export var cc_address: String
@export var subject: String
@export var email_body: String
@export var flags: Array[String] = []
