extends Node

signal connected_to_server_signal
signal lobby_update
signal lobby_indo_updated

const PORT = 8080
#192.168.0.104x
const IP_ADRESS = "127.0.0.1"
const MAX_PLAYERS = 1000

var players = {"id": "player_name"}

var lobbies: Array[int]
var lobbies_ui

var lobby_node := load("res://scenes/menues/lobby.tscn")

@onready var lobbies_spawner := get_tree().root.get_node("/root/LobbiesSpawner")

func _ready() -> void:
	if OS.has_feature("dedicated_server"):	
		create_server()
		print("Server started...")
		print("Waiting fot players")
		
		
func create_server() -> void:
	var server = ENetMultiplayerPeer.new()
	var error = server.create_server(PORT, MAX_PLAYERS)
	if error:
		print("error: " + error)
	
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
	send_lobby_info.rpc_id(id)
	print("Player added with id: " + str(id))
	
func delete_player(id: int) -> void:
	if id in lobbies:
		print("57 Multiplayer Manager")
		lobbies_spawner.get_node("/root/LobbiesSpawner/" + str(id)).free()
		print(lobbies_spawner.get_children())
		lobbies.erase(id)
		send_lobby_info.rpc()
	print("Player deleted with id: " + str(id))
	
func connected_to_server() -> void:
	connected_to_server_signal.emit()
	print("You connected to server")
	
func server_disconnected() -> void:
	print("Server disconnected")
	
@rpc("any_peer", "call_remote")
func send_lobby_info(msg_type=null, lobby_to_update_id=null):
	if msg_type == "players_update":
		lobby_update.emit(lobby_to_update_id)
		return
	lobby_update.emit()
	
	
@rpc("any_peer", "call_remote")
func create_lobby(lobby_name: String, lobby_max_players_value: int, lobby_author_id: int) -> void:
	if multiplayer.is_server():
		if !lobby_author_id in lobbies:
			print("lobby creating...")
			var new_lobby = lobby_node.instantiate()
			
			new_lobby.lobby_name = lobby_name
			new_lobby.lobby_id = lobby_author_id
			new_lobby.max_players = lobby_max_players_value
			new_lobby.author_id = lobby_author_id
			new_lobby.name = str(lobby_author_id)

			lobbies_spawner.add_child(new_lobby)
			lobbies.append(int(new_lobby.lobby_id))
			
			add_player_to_lobby(lobby_author_id, new_lobby.lobby_id)
			
			send_lobby_info.rpc()
			print("lobby update emiting")
			
			print("New lobby added with name: " + str(new_lobby.lobby_name) + " with id: " + str(new_lobby.lobby_id)
		 	+ " with max players value: " + str(new_lobby.max_players))
			
			
@rpc("any_peer", "call_remote")
func add_player_account(player_id: int, player_name: String):
	players[str(player_id)] = player_name
	print("Player account added with id: " + str(player_id) + " with name" + player_name)


@rpc("any_peer", "call_remote")
func add_player_to_lobby(player_id: int, lobby_id: int):
	if multiplayer.is_server():
		var lobby: Lobby = lobbies_spawner.get_node(str(lobby_id))
		if lobby:
			lobby.add_player_to_lobby(player_id, players[str(player_id)])
			print(lobbies_spawner.get_node(str(lobby_id)).players_id_dict.values())
	
	
