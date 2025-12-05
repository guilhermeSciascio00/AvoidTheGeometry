extends Node2D
class_name GameScene

#References
@export var enemies : Array[PackedScene]
var MAIN_MENU = load("res://Scenes/MainMenu.tscn")

@onready var game_pause_panel : Panel = $GameCanvas/PauseMenu
@onready var game_over_panel: Panel = $GameCanvas/GameOverPanel

@onready var player: Player = $Player
@onready var wave_label: RichTextLabel = $GameCanvas/WaveLabel
@onready var wave_up_sfx: AudioStreamPlayer2D = $WaveUpSFX

#Timers
@onready var start_timer: Timer = $StartTimer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var difficult_increaser_timer: Timer = $DifficultIncreaserTimer

#Game_Variables
var currentWave : int = 0
var base_spawn_timer : float = 0
var min_enemy_speed : float = 120.0
var max_enemy_speed : float = 200.0
var multiplier_factor : float = 0.040
const MIN_SPEED_CAP : float = 325.0
const MAX_SPEED_CAP : float = 380.0

func _ready() -> void:
	start_timer.start()
	wave_label.text = "Wave: " + str(currentWave)
	base_spawn_timer = spawn_timer.wait_time

func _process(_delta: float) -> void:
	game_pause()

func _on_start_timer_timeout() -> void:
	difficult_increaser_timer.start()
	spawn_timer.start()
	
func _on_spawn_timer_timeout() -> void:
	if player.get_player_state() == player.STATES.Stopped:
		spawn_timer.stop()
		return
		
	var enemy : Enemy = enemies.pick_random().instantiate()

	var spawn_location : PathFollow2D = $EnemyPath/EnemySpawnLocation
	spawn_location.progress_ratio = randf()
	enemy.position = spawn_location.position
	
	var direction = spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 2, PI / 2)
	enemy.rotation = direction
	
	var velocity = Vector2(randf_range(min_enemy_speed,max_enemy_speed), 0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	add_child(enemy)


func _on_difficult_increaser_timer_timeout() -> void:
	if player.get_player_state() == player.STATES.Stopped:
		difficult_increaser_timer.stop()
		return
		
	on_wave_up()
	
func on_wave_up() -> void:
	currentWave += 1
	wave_label.text = "Wave: " + str(currentWave)
	wave_up_sfx.play()
	
	spawn_timer.wait_time -= 0.020
	spawn_timer.wait_time += randf_range(-0.005, 0.015)
	spawn_timer.wait_time = clampf(spawn_timer.wait_time, 0.095, base_spawn_timer)
	#print(spawn_timer.wait_time)
	
	min_enemy_speed += (min_enemy_speed * multiplier_factor)
	#print(min_enemy_speed)
	min_enemy_speed = clampf(min_enemy_speed, 0, MIN_SPEED_CAP)
	
	max_enemy_speed += (max_enemy_speed * multiplier_factor)
	max_enemy_speed = clampf(max_enemy_speed, 0, MAX_SPEED_CAP)

func game_pause() -> void:
	if Input.is_action_just_pressed("GamePause"):
		Engine.time_scale = 0
		game_pause_panel.visible = true

func game_resume() -> void:
	Engine.time_scale = 1
	game_pause_panel.visible = false

func change_to_main_menu() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)

func reload_scene() -> void:
	get_tree().reload_current_scene()

func _on_player_on_game_over() -> void:
	if game_over_panel != null:
		game_over_panel.visible = true
		ScoreManager.update_score(currentWave)
		ScoreManager.update_high_score()
		FileData.data["HighScore"] = ScoreManager.get_high_score()

func _on_play_again_btn_pressed() -> void:
	reload_scene()

func _on_back_to_menu_btn_pressed() -> void:
	change_to_main_menu()

func _on_resume_btn_pressed() -> void:
	game_resume()

func _on_back_to_menu_btn_pause_pressed() -> void:
	game_resume()
	change_to_main_menu()
