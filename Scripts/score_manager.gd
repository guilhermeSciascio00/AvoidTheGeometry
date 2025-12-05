extends Node

var score = 0
var high_score = 0

func _ready() -> void:
	high_score = FileData.data["HighScore"]

func update_score(newScore : int) -> void:
	score = newScore

func update_high_score() -> void:
	if score > high_score:
		high_score = score
	else:
		high_score = high_score

func reset_score() -> void:
	score = 0

func reset_high_score() -> void:
	high_score = 0

func get_high_score() -> int:
	return high_score
