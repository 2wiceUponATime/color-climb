extends Node2D

@onready var file_dialog: FileDialog = $FileDialog

func _ready() -> void:
	if OS.has_feature("pc"):
		var window = get_window()
		window.position -= window.size/2
		window.size *= 2



#func get_screenshot_path() -> String:
	#var base = "user://screenshot-"
	#var extension = ".png"
	#var i = 0
	#while FileAccess.file_exists(base + str(i) + extension):
		#i += 1
	#return base + str(i) + extension

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("screenshot"):
		var capture = get_viewport().get_texture().get_image()
		file_dialog.current_file = "screenshot.png"
		file_dialog.popup_centered_ratio()
		get_tree().paused = true
		var path = await file_dialog.file_selected
		get_tree().paused = false
		print(path)
		capture.save_png(path)


func _on_file_dialog_canceled() -> void:
	get_tree().paused = false
