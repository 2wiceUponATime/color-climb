extends Node2D

const PORT = 7777
const UDP_PORT = 9999

@onready var games: VBoxContainer = $GameScroll/Games
var udp := PacketPeerUDP.new()
var servers := {}

func exit():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func start_client(address: String):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = peer
	await multiplayer.connected_to_server

func add_server(ip: String) -> void:
	if ip in servers:
		return
	servers[ip] = null
	var server_button = Button.new()
	server_button.text = ip
	server_button.pressed.connect(func ():
		await start_client(ip)
		Save.disabled = true
		Save.data = {}
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	)
	games.add_child(server_button)

func _ready():
	var err := udp.bind(UDP_PORT)
	if err != OK:
		print("Error with UDP: ", err)
		exit()
	
func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		exit()
	if udp.get_available_packet_count() > 0:
		var packet = udp.get_packet().get_string_from_utf8()
		var server_ip = udp.get_packet_ip()
		if packet == "COLOR_CLIMB_SERVER":
			add_server(server_ip)
