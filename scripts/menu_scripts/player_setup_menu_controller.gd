extends Control

@export var player_name_line_edit: LineEdit

func _on_connect_button_pressed() -> void:
	var player_name = player_name_line_edit.text
	AccountManager.set_player_name(player_name)

	SceneSwitcher.change_scene_to_file("res://scenes/menues/game_waiting_menu.tscn")


func _on_back_button_pressed() -> void:
	if multiplayer.has_multiplayer_peer():
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		
	SceneSwitcher.change_scene_to_file("res://scenes/menues/main_menu.tscn")
