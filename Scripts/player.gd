extends CharacterBody2D
class_name Player

enum STATES {
	Moving = 0,
	Stopped = 1
}

#Custom signal
signal on_game_over 

#Player Variables
@export var player_speed = 100
@export var player_lives = 3
@export var bound_offset = 20
var player_state : STATES = STATES.Moving

#References
@onready var lives_label: Label = $Lives_Label
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	lives_label.text = str(player_lives)

func _process(_delta: float) -> void:
	game_over()

func _physics_process(_delta: float) -> void:
	if player_state == STATES.Stopped:
		return
		
	var target_position = get_current_mouse_pos()
	velocity = position.direction_to(target_position) * player_speed
	
	position.x = clampf(position.x, bound_offset, get_viewport_rect().size.x - bound_offset)
	
	position.y = clampf(position.y, bound_offset, get_viewport_rect().size.y - bound_offset)
	
	if position.distance_to(target_position) > 10:
		move_and_slide()

func get_current_mouse_pos() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	#var screen_size = get_viewport_rect().size
	return mouse_pos
	#if (mouse_pos.x >= 0 and mouse_pos.x <= screen_size.x) and (mouse_pos.y >= 0 and mouse_pos.y <= screen_size.y):
		#return mouse_pos
	#else:
		#return position
		
func take_damage() -> void:	
	player_lives -= 1

func game_over() -> void:
	if player_state == STATES.Moving:
		if player_lives <= 0:
			player_lives = 0
			collision_shape_2d.disabled = true
			player_state = STATES.Stopped
			on_game_over.emit()
			
		lives_label.text = str(player_lives)

func get_player_state() -> STATES:
	return player_state
