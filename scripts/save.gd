extends Node

const SAVE_DIR = "user://saves/"
var save_as: String = "save"
var data: Dictionary = {}

func open(save_name: String):
	save_as = save_name
	var path = SAVE_DIR + save_name + ".json"
	var text = FileAccess.get_file_as_string(path)
	if text:
		var result = JSON.parse_string(text)
		data = result if result is Dictionary else {}

func create_dir(path: String):
	path = path.rstrip("/")
	if not FileAccess.file_exists("path"):
		var dir = DirAccess.open(path.get_base_dir())
		dir.make_dir(path.get_file())

func save() -> void:
	create_dir(SAVE_DIR)
	var path = SAVE_DIR + save_as + ".json"
	var text = JSON.stringify(data)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(text)
