extends Node

var save_path = "user://save_data.json"

func save_game(data):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_game():
	if not FileAccess.file_exists(save_path):
		return {}
	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse_string(content)
	return result if typeof(result) == TYPE_DICTIONARY else {}
