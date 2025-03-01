extends Node2D

@onready var continue_game: Button = $VBoxContainer/ContinueGame

func _ready() -> void:
	Save.open("save")
	if Save.data:
		continue_game.disabled = false

func _on_new_game_pressed() -> void:
	Save.data = {}
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_continue_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
