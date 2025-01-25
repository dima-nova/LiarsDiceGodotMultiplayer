extends Node2D

@export var player_game_card: PackedScene
@export var spawn_point: PathFollow2D
@export var players_list: Node2D

func _ready() -> void:
	spawn_point.progress_ratio = 0.0
	
	var spawn_step = 1.0 / PlayersSpawner.get_child_count()
	print(1/2)
	for player: Player in PlayersSpawner.get_children():
		
		var new_player_card = player_game_card.instantiate()
		new_player_card.player_name = player.player_name
		new_player_card.player_id = player.player_id
		
		new_player_card.global_position = spawn_point.global_position
		players_list.add_child(new_player_card)
		
		spawn_point.progress_ratio += spawn_step


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
