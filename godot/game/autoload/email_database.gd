extends Node
class_name EmailDatabase

const _email_paths_by_id := {
	# Monday
	"1_1_onboarding": "res://data/email/monday/1_1_onboarding.tres",
	"1_2_submit_po": "res://data/email/monday/1_2_submit_po.tres",
	"1_3_antivirus_introduction": "res://data/email/monday/1_3_antivirus_introduction.tres",
	"1_4_antivirus_activated": "res://data/email/monday/1_4_antivirus_activated.tres",
	"1_5_littlegenius_po": "res://data/email/monday/1_5_littlegenius_po.tres",
	"1_6_trippo_ad": "res://data/email/monday/1_6_trippo_ad.tres",
	"1_7_happyminimarket_po": "res://data/email/monday/1_7_happyminimarket_po.tres",
	"1_8_cybernewsdaily": "res://data/email/monday/1_8_cybernewsdaily.tres",
	"1_9_fake_po": "res://data/email/monday/1_9_fake_po.tres",
	"1_10_printpro_po": "res://data/email/monday/1_10_printpro_po.tres",
	
	# Tuesday
}

static func get_email_path_by_id(id: String) -> String:
	return _email_paths_by_id[id]
