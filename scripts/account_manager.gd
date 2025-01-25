extends Node

var player_name: String

func set_player_name(player_input_name: String):
	self.player_name = player_input_name
	MultiplayerManager.add_player_info.rpc_id(1, multiplayer.get_unique_id(), player_input_name)
