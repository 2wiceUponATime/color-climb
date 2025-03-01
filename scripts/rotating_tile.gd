extends StaticBody2D

@onready var center: Sprite2D = $Center

func _on_rotation_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "rotation", rotation + PI/2, 1)
	tween.parallel().tween_property(center, "rotation", center.rotation - PI/2, 1)
	
