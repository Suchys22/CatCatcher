
extends Node
signal send_data(data)

const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"

func _ready() -> void:
	load_game()

func load_game():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "SůChyyY151566")
		if error == OK:
			emit_signal("send_data", file.get_var())
			file.close()

func _on_Player_save_game(data) -> void:
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "SůChyyY151566")
	if error == OK:
		file.store_var(data)
		file.close()
