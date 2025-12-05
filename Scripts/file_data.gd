extends Node

const PATH = "user://"
const FILE_NAME = "save-data.data"

var data : Dictionary
var access: FileAccess
var encryption : Encryption

func _ready() -> void:
	encryption = ResourceLoader.load("res://Scripts/my_001.tres")
	load_game()

func new_game() -> void:
	data = {
		"MasterVolume" : 1,
		"MusicVolume" : 1,
		"SFXVolume" : 1,
		"HighScore" : 0
	}
	
func save_game() -> void:
	access = FileAccess.open_encrypted_with_pass(PATH + FILE_NAME, FileAccess.WRITE, encryption.key)
	access.store_string(JSON.stringify(data))
	access.close()
	
func load_game() -> void:
	if FileAccess.file_exists(PATH + FILE_NAME):
		access = FileAccess.open_encrypted_with_pass(PATH + FILE_NAME, FileAccess.READ, encryption.key)
		data = JSON.parse_string(access.get_as_text())
		access.close()
	else:
		new_game()
		save_game()
