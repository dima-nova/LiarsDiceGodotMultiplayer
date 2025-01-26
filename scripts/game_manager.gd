extends Node2D

@export var player_game_card: PackedScene
@export var spawn_point: PathFollow2D
@export var players_list: Node2D

var players: Dictionary

func _ready() -> void:
	spawn_point.progress_ratio = 0.0
	var spawn_step = 1.0 / PlayersSpawner.get_child_count()

	# Own card 
	add_player_card(multiplayer.get_unique_id())
	spawn_point.progress_ratio += spawn_step
	
	#other cards
	for player: Player in PlayersSpawner.get_children():
		if !str(player.player_id) in players.keys():
			add_player_card(player.player_id)
			spawn_point.progress_ratio += spawn_step
		
func add_player_card(player_id):
	var player: Player = PlayersSpawner.get_node(str(player_id))
	print("add player with name: " + player.player_name)
	var new_player_card = player_game_card.instantiate()

	new_player_card.player_name = player.player_name
	new_player_card.player_id = player.player_id
		
	new_player_card.global_position = spawn_point.global_position
	players_list.add_child(new_player_card)
	players[str(player_id)] = player.player_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
