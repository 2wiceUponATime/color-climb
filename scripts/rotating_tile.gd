extends StaticBody2D

@onready var center: Sprite2D = $Center
@export var rotations: float = 0:
	set(value):
		rotations = fmod(value, 4)
		rotation = value * PI/2

func _enter_tree() -> void:
	if multiplayer.is_server():
		$MultiplayerSynchronizer.set_multiplayer_authority(multiplayer.get_unique_id())

func _on_rotation_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "rotations", rotations + 1, 1)
	tween.parallel().tween_property(center, "rotation", -PI/2 - rotation, 1)
	
