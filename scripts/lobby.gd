extends Node
class_name Lobby

@export var lobby_name: String
@export var lobby_id: int
@export var max_players: int
@export var author_id: int
@export var players_id_dict = {}

func add_player_to_lobby(player_id: int, player_name: String):
	if !str(player_id) in self.players_id_dict.keys():
		players_id_dict[str(player_id)] = player_name
		print("Player with name: " + player_name + "join lobby with name: " + lobby_name)
		return true
		
func delete_player_from_lobby(player_id: int):
	pass
	#if player_id in self.players_id_list:
		#players_id_list.erase(player_id)
