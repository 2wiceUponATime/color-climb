extends Node

func _ready() -> void:
	if OS.has_feature("pc"):
		var window = get_window()
		window.position -= window.size/2
		window.size *= 2
