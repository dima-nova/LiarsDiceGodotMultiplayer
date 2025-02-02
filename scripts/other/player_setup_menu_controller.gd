extends Control

@export var player_name_line_edit: LineEdit

func _on_connect_button_pressed() -> void:
	var player_name = player_name_line_edit.text
	AccountManager.set_player_name(player_name)

	get_tree().change_scene_to_file("res://scenes/menues/game_waiting_menu.tscn")
