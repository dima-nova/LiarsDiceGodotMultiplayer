extends Node

signal bet_update

# Game variables
@export var current_player_id: int
@export var current_bet_number: int
@export var current_face_value: int:
	set(new_number):
		current_face_value = clamp(new_number, 1, 6)


func _ready() -> void:
	pass
	
	
func start_game():
	if multiplayer.is_server():
		prepare_for_game()
	

func prepare_for_game():
	if multiplayer.is_server():
		randomize()
		current_player_id = randi() % PlayersSpawner.get_child_count()
		print(current_player_id)
		PlayersSpawner.get_child(current_player_id).is_move = true
		current_bet_number = 0
		current_face_value = 1
	
		send_game_state.rpc(current_player_id, current_bet_number, current_face_value)
		
		for player: Player in PlayersSpawner.get_children():
			player.dices_number = 5
	
	
@rpc("any_peer", "call_remote")
func send_game_state(current_player_id_: int, current_bet_number_: int, current_face_value_: int):
	self.current_player_id = current_player_id_
	self.current_bet_number = current_bet_number_
	self.current_face_value = current_face_value_
	bet_update.emit()



func _process(delta: float) -> void:
	pass
