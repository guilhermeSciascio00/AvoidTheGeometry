extends Node2D
class_name MainMenu

#Game_Scenes / References
var GAME_SCENE = load("res://Scenes/Game-Scene.tscn")
@onready var settings_menu: Panel = $CanvasLayer/Settings
@onready var high_score: RichTextLabel = $CanvasLayer/HighScore

func _ready() -> void:
	high_score.text = "HighScore: %d" % ScoreManager.get_high_score()
	pass
	
#Loads game scene
func play_game():
	get_tree().change_scene_to_packed(GAME_SCENE)

func settings_menu_switch():
	if settings_menu:
		settings_menu.visible = not settings_menu.visible

func quit_game():
	FileData.save_game()
	get_tree().quit()

func _on_button_pressed() -> void:
	play_game()

func _on_button_2_pressed() -> void:
	settings_menu_switch()

func _on_back_btn_pressed() -> void:
	settings_menu_switch()
	FileData.save_game()

func _on_button_3_pressed() -> void:
	quit_game()
