extends Node2D

const ADDRESS = "127.0.0.1"
const PORT = 7777
const MAX_CLIENTS = 20

@onready var continue_game: Button = $Buttons/ContinueGame

func start_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer

func start_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	await multiplayer.connected_to_server

func _ready() -> void:
	Save.open("save")
	multiplayer.multiplayer_peer = null
	if Save.data:
		continue_game.disabled = false
	if not OS.has_feature("web"):
		$Buttons/Join/LineEdit.editable = true
		$Buttons/Join/JoinGame.disabled = false

func _on_new_game_pressed() -> void:
	start_server()
	Save.data = {}
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_continue_game_pressed() -> void:
	start_server()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_join_game_pressed() -> void:
	await start_client()
	Save.data = {}
	get_tree().change_scene_to_file("res://scenes/main.tscn")
