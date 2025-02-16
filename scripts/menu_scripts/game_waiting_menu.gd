extends Control

@export var players_list: VBoxContainer
@export var player_card: PackedScene

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# If player connect to the game
	if PlayersSpawner.get_child_count() > players_list.get_child_count():
		for player in PlayersSpawner.get_children():
			if !player.name in players_list.get_children().map(func(child): return child.name) and player.player_name:
				var new_card = player_card.instantiate()
				new_card.player_name = player.player_name
				new_card.name = player.name
				
				players_list.add_child(new_card)
				
				
	# if player disconnect from the game
	if PlayersSpawner.get_child_count() < players_list.get_child_count():
		for card in players_list.get_children():
			if !card.name in PlayersSpawner.get_children().map(func(child): return child.name):
				card.queue_free()
				
		
func _on_start_game_button_pressed() -> void:
	MultiplayerManager.start_game.rpc()


func _on_back_button_pressed() -> void:
	if multiplayer.has_multiplayer_peer():
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		
	SceneSwitcher.change_scene_to_file("res://scenes/menues/main_menu.tscn")
