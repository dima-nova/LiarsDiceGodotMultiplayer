extends Node

signal connected_to_server_signal

const PORT = 9999
#192.168.0.104
const IP_ADRESS = "127.0.0.1"
const MAX_PLAYERS = 1000

@export var player_instance := load("res://scenes/objects/player.tscn")

var is_game_started: bool = false

func _ready() -> void:
	if OS.has_feature("dedicated_server"):	
		create_server()
		print("Server started...")
		print("Waiting fot players")
		
		
func create_server() -> void:
	print("Running server on: " + IP_ADRESS)
	var server = ENetMultiplayerPeer.new()
	var error = server.create_server(PORT, MAX_PLAYERS)
	if error:
		print("error: " + str(error))
	
	multiplayer.multiplayer_peer = server
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(delete_player)
	
	
func join_game() -> bool:
	var client = ENetMultiplayerPeer.new()
	var response = client.create_client(IP_ADRESS, PORT)
	if response == OK:
		multiplayer.multiplayer_peer = client
	
		multiplayer.connected_to_server.connect(connected_to_server)
		multiplayer.server_disconnected.connect(server_disconnected)
		return true
	else:
		return false
	

func add_player(id: int) -> void:
	if !is_game_started:
		var new_player: Player = player_instance.instantiate()
		new_player.player_id = id
		new_player.name = str(id)
	
		PlayersSpawner.add_child(new_player)
		print("Player added with id: " + str(id))
	else:
		print("Game was already started")
	
func delete_player(id: int) -> void:
	if PlayersSpawner.get_node(str(id)):
		PlayersSpawner.get_node(str(id)).queue_free()
	print("Player deleted with id: " + str(id))
	
func connected_to_server() -> void:
	connected_to_server_signal.emit()
	print("You connected to server")
	
func server_disconnected() -> void:
	print("Server disconnected")
					
@rpc("any_peer", "call_remote")
func add_player_info(player_id: int, player_name: String):
	var player = PlayersSpawner.get_node(str(player_id))
	if player:
		PlayersSpawner.get_node(str(player_id)).player_name = player_name
		print("Player info added with id: " + str(player_id) + " with name" + player_name)
	
	
@rpc("any_peer", "call_local")
func start_game():
	if multiplayer.is_server():
		is_game_started = true
		GameManager.start_game()
		return
	
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

	
