extends Node

@export var menu_music_stream_player: AudioStreamPlayer
@export var game_music_stream_player: AudioStreamPlayer

var music_dict: Dictionary = {
	"menu_music": menu_music_stream_player,
	"game_music": game_music_stream_player,
}


func _ready() -> void:
	pass
	
	
func start_game_music():
	menu_music_stream_player.stop()
	game_music_stream_player.play()

func start_menu_music():
	game_music_stream_player.stop()
	menu_music_stream_player.play()
