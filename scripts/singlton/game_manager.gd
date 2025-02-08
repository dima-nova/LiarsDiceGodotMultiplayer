extends Node

signal bet_update
signal round_starting
signal next_turn
signal round_finishing

@export var is_game_started: bool = false

# Game variables
@export var current_player_id: int:
	set(new_id):
		current_player_id = new_id
		next_turn.emit()
@export var previous_player_id: int = 0
			
@export var current_bet_number: int
@export var current_face_value: int:
	set(new_number):
		current_face_value = clamp(new_number, 1, 6)
@export var real_number_of_dice: int
@export var ready_players: int

	
func start_game():
	if multiplayer.is_server():
		prepare_for_game()

func prepare_for_game():
	if multiplayer.is_server():
		randomize()
		current_player_id = randi() % PlayersSpawner.get_child_count()
		
		for player: Player in PlayersSpawner.get_children():
			player.dices_number = 5
	
	
@rpc("any_peer", "call_remote", "reliable")
func send_game_state(current_player_id_: int, current_bet_number_: int, current_face_value_: int):
	self.current_player_id = current_player_id_
	self.current_bet_number = current_bet_number_
	self.current_face_value = current_face_value_
	bet_update.emit()


func start_round():
	if multiplayer.is_server():
		check_dropped_out_players()
		
		if current_player_id:
			PlayersSpawner.get_child(current_player_id).is_move = true
		
		previous_player_id = 0
		current_bet_number = 0
		current_face_value = 1
	
		# Rolling dices
		for player: Player in PlayersSpawner.get_children():
			player.roll_dices()
		
		# Updating ui
		await get_tree().process_frame
		send_game_state.rpc(current_player_id, current_bet_number, current_face_value)
		update_dices_ui.rpc()
	
	
func check_dropped_out_players():
	if multiplayer.is_server():
		for player: Player in PlayersSpawner.get_children():
			if player.dices_number <= 0:
				if player.get_index() == current_player_id:
					player.free()
					take_next_player()
				else:
					player.free()
					print("Player deleted from game")
	
@rpc("any_peer", "call_remote")
func add_ready_player():
	if multiplayer.is_server():
		ready_players += 1
		
		if ready_players == PlayersSpawner.get_child_count():
			ready_players = 0
			start_round()


@rpc("any_peer", "call_remote", "reliable")
func update_dices_ui():
	round_starting.emit()
	
@rpc("any_peer", "call_remote")
func finish_round_ui(real_number_of_dice_: int):
	self.real_number_of_dice = real_number_of_dice_
	round_finishing.emit()


@rpc("any_peer", "call_remote")
func raise_bet(player_id, face_value, dice_number):
	if multiplayer.is_server():
		if PlayersSpawner.get_child(current_player_id).player_id == player_id:
			if face_value >= current_face_value and dice_number >= current_bet_number:
				if face_value > current_face_value or dice_number > current_bet_number:
					current_face_value = face_value
					current_bet_number = dice_number
					
					PlayersSpawner.get_child(current_player_id).is_move = false
					take_next_player()
					PlayersSpawner.get_child(current_player_id).is_move = true
			
					await get_tree().process_frame
					send_game_state.rpc(current_player_id, current_bet_number, current_face_value)
					
					
					
func finish_round():
	PlayersSpawner.get_child(current_player_id).is_move = false


@rpc("any_peer", "call_remote")
func check_last_bet(player_id: int):
	if multiplayer.is_server():
		if player_id == PlayersSpawner.get_child(current_player_id).player_id:
			finish_round()
			
			if current_bet_number <= get_number_of_dices_by_face(current_face_value):
				PlayersSpawner.get_child(current_player_id).dices_number -= 1
				current_player_id = current_player_id
			else:
				PlayersSpawner.get_child(previous_player_id).dices_number -= 1
				current_player_id = previous_player_id

			await get_tree().process_frame
			send_game_state.rpc(current_player_id, current_bet_number, current_face_value)
			finish_round_ui.rpc(get_number_of_dices_by_face(current_face_value))
			
		
func get_number_of_dices_by_face(face_value: int):
	var dice_number: int = 0
	for player: Player in PlayersSpawner.get_children():
		dice_number += player.dices.count(face_value)
		
		if face_value != 1:
			dice_number += player.dices.count(1)
	
	return dice_number
				
func take_next_player():
	previous_player_id = current_player_id
	
	if current_player_id + 1 >= PlayersSpawner.get_child_count():
		current_player_id = 0
	else:
		current_player_id += 1

				
