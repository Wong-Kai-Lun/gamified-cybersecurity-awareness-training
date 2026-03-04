extends Node
class_name FileDatabase

const _file_paths_by_id := {
	"1_5_littlegenius_po": "res://data/file/monday/1_5_littlegenius_po.tres",
	"1_7_happyminimarket_po": "res://data/file/monday/1_7_happyminimarket_po.tres",
	"1_9_fake_po": "res://data/file/monday/1_9_fake_po.tres",
	"1_10_printpro_po": "res://data/file/monday/1_10_printpro_po.tres",
	
	"sample_adware": "res://data/file/test/sample_adware.tres",
	"sample_ransomware": "res://data/file/test/sample_ransomware.tres"
}


static func get_file_path_by_id(id: String) -> String:
	return _file_paths_by_id[id]
