extends Node2D

@onready var file_dialog: FileDialog = $FileDialog

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("screenshot"):
		var capture = get_viewport().get_texture().get_image()
		file_dialog.current_file = "screenshot.png"
		file_dialog.popup_centered_ratio()
		get_tree().paused = true
		var path = await file_dialog.file_selected
		get_tree().paused = false
		capture.save_png(path)
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_file_dialog_canceled() -> void:
	get_tree().paused = false
