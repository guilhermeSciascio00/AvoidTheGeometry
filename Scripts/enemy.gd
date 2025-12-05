extends RigidBody2D
class_name Enemy

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player : Player = body
		player.take_damage()
		queue_free()
