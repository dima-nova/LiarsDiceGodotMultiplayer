extends Node

var guest_player_name: String

func set_guest_name(guest_name: String):
	guest_player_name = guest_name
	MultiplayerManager.add_player_account.rpc_id(1, multiplayer.get_unique_id(), guest_name)
