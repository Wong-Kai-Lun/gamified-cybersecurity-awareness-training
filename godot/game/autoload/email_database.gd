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
	"2_1_impersonation": "res://data/email/tuesday/2_1_impersonation.tres",
	"2_2_submit_po": "res://data/email/tuesday/2_2_submit_po.tres",
	"2_3_cybernewsdaily": "res://data/email/tuesday/2_3_cybernewsdaily.tres",
	"2_4_jusco_po": "res://data/email/tuesday/2_4_jusco_po.tres",
	"2_5_c17_recruit": "res://data/email/tuesday/2_5_c17_recruit.tres",
	"2_6_fake_mike_1": "res://data/email/tuesday/2_6_fake_mike_1.tres",
	"2_7_koperasi": "res://data/email/tuesday/2_7_koperasi.tres",
	"2_8_lighthouse": "res://data/email/tuesday/2_8_lighthouse.tres",
	"2_9_fake_mike_2": "res://data/email/tuesday/2_9_fake_mike_2.tres",
	"2_10_real_mike": "res://data/email/tuesday/2_10_real_mike.tres",
}

static func get_email_path_by_id(id: String) -> String:
	return _email_paths_by_id[id]
