extends Node2D

const PORT = 7777
const MAX_CLIENTS = 20
const PLAYER = preload("res://scenes/player.tscn")

@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var players: Node2D = $Players

func _ready() -> void:
	join_game(Global.get_id())

@rpc("any_peer", "call_local", "reliable")
func join_game(id):
	if not Global.is_server():
		return
	print("player " + str(id) + " joined game")
	var player = PLAYER.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)
	player.get_node("MultiplayerSynchronizer").set_multiplayer_authority(id)
	players.add_child(player)
