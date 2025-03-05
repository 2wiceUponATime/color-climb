extends Node

var singleplayer: bool = OS.has_feature("web")

func _ready() -> void:
	if OS.has_feature("pc"):
		var window = get_window()
		window.position -= window.size/2
		window.size *= 2

func get_id() -> int:
	if singleplayer:
		return 0
	return multiplayer.get_unique_id()

func is_server() -> bool:
	if singleplayer:
		return true
	return multiplayer.is_server()

func is_authority(node: Node) -> bool:
	if singleplayer:
		return true
	return node.is_multiplayer_authority()
