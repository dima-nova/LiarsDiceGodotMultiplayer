extends Node

signal bet_update
signal round_starting
signal next_turn

# Game variables
@export var current_player_id: int:
	set(new_id):
		current_player_id = new_id
		next_turn.emit()
			
@export var current_bet_number: int
@export var current_face_value: int:
	set(new_number):
		current_face_value = clamp(new_number, 1, 6)

	
func start_game():
	if multiplayer.is_server():
		prepare_for_game()
		start_round()
	

func prepare_for_game():
	if multiplayer.is_server():
		randomize()
		current_player_id = randi() % PlayersSpawner.get_child_count()
		PlayersSpawner.get_child(current_player_id).is_move = true
		current_bet_number = 1
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


func start_round():
	# Rolling dices
	for player: Player in PlayersSpawner.get_children():
		player.roll_dices()
		
	# Updating ui
	update_dices_ui.rpc()


@rpc("any_peer", "call_remote")
func update_dices_ui():
	round_starting.emit()

@rpc("any_peer", "call_remote")
func raise_bet(player_id, face_value, dice_number):
	if multiplayer.is_server():
		if PlayersSpawner.get_child(current_player_id).player_id == player_id:
			if face_value >= current_face_value and dice_number >= current_bet_number:
				if face_value > current_face_value or dice_number > current_bet_number:
					current_face_value = face_value
					current_bet_number = dice_number
					take_next_player()
			
					send_game_state.rpc(current_player_id, current_bet_number, current_face_value)
				
func take_next_player():
	PlayersSpawner.get_child(current_player_id).is_move = false
	
	if current_player_id + 1 >= PlayersSpawner.get_child_count():
		current_player_id = 0
	else:
		current_player_id += 1
	
	PlayersSpawner.get_child(current_player_id).is_move = true
	
				
