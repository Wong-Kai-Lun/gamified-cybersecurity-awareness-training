extends Node
class_name FileDatabase

const _file_paths_by_id := {
	# Monday
	"1_5_littlegenius_po": "res://data/file/monday/1_5_littlegenius_po.tres",
	"1_7_happyminimarket_po": "res://data/file/monday/1_7_happyminimarket_po.tres",
	"1_9_fake_po": "res://data/file/monday/1_9_fake_po.tres",
	"1_10_printpro_po": "res://data/file/monday/1_10_printpro_po.tres",
	
	# Tuesday
	"2_4_jusco_po": "res://data/file/tuesday/2_4_jusco_po.tres",
	"2_6_fake_po": "res://data/file/tuesday/2_6_fake_po.tres",
	"2_7_koperasi": "res://data/file/tuesday/2_7_koperasi.tres",
	"2_8_lighthouse": "res://data/file/tuesday/2_8_lighthouse.tres",
	"2_9_fake_po": "res://data/file/tuesday/2_9_fake_po.tres",
	"2_10_inkspirations_po": "res://data/file/tuesday/2_10_inkspirations_po.tres",
	"2_10_lina_po": "res://data/file/tuesday/2_10_lina_po.tres",
	
	"sample_adware": "res://data/file/test/sample_adware.tres",
	"sample_ransomware": "res://data/file/test/sample_ransomware.tres"
}


static func get_file_path_by_id(id: String) -> String:
	return _file_paths_by_id[id]
