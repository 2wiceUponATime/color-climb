extends Node2D

const ADDRESS = "127.0.0.1"
const PORT = 7777
const UDP_PORT = 9999
const MAX_CLIENTS = 20

@onready var continue_game: Button = $Buttons/ContinueGame
var udp: PacketPeerUDP

func start_server():
	if Global.singleplayer:
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer

func _ready() -> void:
	Save.open("save")
	multiplayer.multiplayer_peer = null
	if Save.data:
		continue_game.disabled = false
	if DisplayServer.get_name() == "headless":
		_on_new_game_pressed()
	if not OS.has_feature("web"):
		$Buttons/JoinGame.disabled = false
	if not Global.singleplayer:
		udp = PacketPeerUDP.new()
		udp.set_dest_address("255.255.255.255", UDP_PORT)
		udp.bind(UDP_PORT)

func _process(_delta: float) -> void:
	if udp.get_available_packet_count() > 0:
		var packet = udp.get_packet()
		var ip = udp.get_packet_ip()
		var port = udp.get_packet_port()
		print("Received packet from %s:%s" % [ip, port])
		print("Packet data: %s" % packet.get_string_from_utf8())

func _on_new_game_pressed() -> void:
	start_server()
	Save.data = {}
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_continue_game_pressed() -> void:
	start_server()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_join_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/join_game.tscn")
