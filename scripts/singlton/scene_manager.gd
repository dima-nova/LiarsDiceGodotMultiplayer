extends Node

var previous_scene_file_path: String
var current_scene_file_path: String = "res://scenes/menues/main_menu.tscn"

@export var animation_player: AnimationPlayer

func change_scene_to_file(file_path: String) -> void:
	previous_scene_file_path = current_scene_file_path
	animation_player.play("dissolve")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(file_path)
	animation_player.play_backwards("dissolve")

	
