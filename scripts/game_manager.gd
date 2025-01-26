extends Node2D

@export_group("UI")
@export var player_game_card: PackedScene
@export var spawn_point: PathFollow2D
@export var players_list: Node2D

var players: Dictionary

# Game variables
var current_player_id: int
var current_bet_number: int
var current_face_value: int:
	set(new_number):
		current_face_value = clamp(new_number, 1, 6)
		
		

func _ready() -> void:
	player_cards_generation()
	
	# Starting the game
	randomize()
	current_player_id = randi() % PlayersSpawner.get_child_count() + 1
	PlayersSpawner.get_child(current_player_id).is_move = true
	current_bet_number = 0
	current_face_value = 1
	
	
	
func _process(delta: float) -> void:
	pass

	
func player_cards_generation():
		spawn_point.progress_ratio = 0.0
		var spawn_step = 1.0 / PlayersSpawner.get_child_count()

		# Own card 
		add_player_card(multiplayer.get_unique_id(), true)
		spawn_point.progress_ratio += spawn_step
	
		#other cards
		for player: Player in PlayersSpawner.get_children():
			if !str(player.player_id) in players.keys():
				add_player_card(player.player_id)
				spawn_point.progress_ratio += spawn_step
		
func add_player_card(player_id, is_own: bool=false):
	var player: Player = PlayersSpawner.get_node(str(player_id))
	print("add player with name: " + player.player_name)
	var new_player_card = player_game_card.instantiate()

	new_player_card.player_name = player.player_name
	new_player_card.player_id = player.player_id
		
	new_player_card.global_position = spawn_point.global_position
	if is_own:
		new_player_card.is_own_card = true
	
	players_list.add_child(new_player_card)
	players[str(player_id)] = player.player_name
