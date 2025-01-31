extends Node2D

@export_group("PackedScenes")
@export var player_game_card: PackedScene
@export var dice_card: PackedScene

@export_group("UI")
@export var spawn_point: PathFollow2D
@export var players_list: Node2D

@export var main_bet_dice: Control
@export var main_bet_value_label: Label
@export var check_bet_dice: Control
@export var check_bet_value_label: Label

@export var check_bet_animation_player: AnimationPlayer
@export var menu_animation_player: AnimationPlayer

@export var raise_menu_button: Button
@export var action_buttons: HBoxContainer
@export var waiting_label: Label
@export var dice_number_slider: HSlider
@export var dice_number_slider_label: Label
@export var dice_face_value_order: Control
@export var raise_input_menu: Control
@export var dice_layer_1: HBoxContainer
@export var dice_layer_2: HBoxContainer

var players: Dictionary
var spawn_step: float
var check_bet_plus_times_to_play: int

var check_bet_start_anim_name = "check_bet_start"
var check_bet_plus_anim_name = "check_bet_plus"
var true_bet_anim_name = "true_bet"
var false_bet_anim_name = "false_bet"
		


func _ready() -> void:
	# Connecting signals
	GameManager.bet_update.connect(update_bet)
	GameManager.round_starting.connect(update_start_ui)
	GameManager.next_turn.connect(make_turn_possibility)
	GameManager.round_finishing.connect(finish_round)
	# Spawn player cards
	spawn_point.progress_ratio = 0.0
	spawn_step = 1.0 / PlayersSpawner.get_child_count()
	player_cards_generation()
	
	check_bet_animation_player.play("RESET")
	
	GameManager.add_ready_player.rpc_id(1)

	
func update_bet():
	main_bet_dice.update_roll()
	main_bet_dice.set_dice_value(GameManager.current_face_value)
	main_bet_value_label.text = str(GameManager.current_bet_number)
	
	
	dice_number_slider.min_value = GameManager.current_bet_number
	dice_number_slider.value = dice_number_slider.min_value
	dice_number_slider.max_value = dice_number_slider.min_value + 10
	
	dice_number_slider_label.text = str(dice_number_slider.min_value)
	
	dice_face_value_order.ordered_value = GameManager.current_face_value
	
	
func update_start_ui():
	await get_tree().process_frame
	#Update players cards
	if PlayersSpawner.get_child_count() < players_list.get_child_count():
		for player in players_list.get_children():
			player.free()
		players = {}
		spawn_point.progress_ratio = 0.0
		spawn_step = 1.0 / PlayersSpawner.get_child_count()
		player_cards_generation()
	
	
	# Update dices UI

	if PlayersSpawner.has_node(str(multiplayer.get_unique_id())):
		var player_dices: Array = PlayersSpawner.get_node(str(multiplayer.get_unique_id())).dices
		clean_dice_list()
		for dice_i in player_dices.size():
			if dice_layer_1.get_child_count() <= dice_layer_2.get_child_count() + 1 \
			 and dice_layer_2.get_child_count() == 0 or dice_layer_1.get_child_count() == dice_layer_2.get_child_count():
				var new_dice = dice_card.instantiate()
				dice_layer_1.add_child(new_dice)
				new_dice.roll()
				new_dice.set_dice_value(player_dices[dice_i])
			else:
				var new_dice = dice_card.instantiate()
				dice_layer_2.add_child(new_dice)
				new_dice.roll()
				new_dice.set_dice_value(player_dices[dice_i])
		
		
func clean_dice_list():
	for dice in dice_layer_1.get_children():
		dice.free()
	for dice in dice_layer_2.get_children():
		dice.free()
		

func make_turn_possibility():
	if PlayersSpawner.get_child(GameManager.current_player_id).player_id == multiplayer.get_unique_id():
		waiting_label.hide()
		action_buttons.visible = true
	else:
		if raise_input_menu.visible:
			menu_animation_player.play_backwards("raise_menu_open")
			_on_raise_menu_button_pressed()
		action_buttons.hide()
		waiting_label.visible = true
		

func finish_round():
	check_bet_dice.set_dice_value(GameManager.current_face_value)
	check_bet_dice.update_roll()
	check_bet_value_label.text = str(0)
	check_bet_animation_player.play(check_bet_start_anim_name)
	check_bet_plus_times_to_play = GameManager.real_number_of_dice
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in [check_bet_start_anim_name, check_bet_plus_anim_name]:
		if check_bet_plus_times_to_play > 0:
			check_bet_plus_times_to_play -= 1
			check_bet_value_label.text = str(check_bet_value_label.text.to_int() + 1)
			check_bet_animation_player.play(check_bet_plus_anim_name)
		else:
			if GameManager.real_number_of_dice >= GameManager.current_bet_number:
				check_bet_animation_player.play(true_bet_anim_name)
			else:
				check_bet_animation_player.play(false_bet_anim_name)
				
	elif anim_name in [true_bet_anim_name, false_bet_anim_name]:
		var player_dices = PlayersSpawner.get_node(str(multiplayer.get_unique_id())).dices_number
		if player_dices < dice_layer_1.get_child_count() + dice_layer_2.get_child_count():
			if dice_layer_2.get_child(0):
				dice_layer_2.get_child(0).lose()
			elif dice_layer_1.get_child(0):
				dice_layer_1.get_child(0).lose()
		
		var player_card = players_list.get_node(str(PlayersSpawner.get_child(GameManager.current_player_id).player_id))
		player_card.lose_dice_anim_finished.connect(player_card_lose_anim_finished)
		player_card.lose_dice_anim()
		
func player_card_lose_anim_finished():
	check_bet_animation_player.play("RESET")
	GameManager.add_ready_player.rpc_id(1)
				

func player_cards_generation():
	"""This function generate players cards on the game field"""
	
	if PlayersSpawner.has_node(str(multiplayer.get_unique_id())):
		for player: Player in PlayersSpawner.get_children():
			if !str(player.player_id) in players.keys():
				if player.player_id == multiplayer.get_unique_id():
					add_player_card(multiplayer.get_unique_id())
					spawn_point.progress_ratio += spawn_step
				elif spawn_point.progress_ratio > 0:
					add_player_card(player.player_id)
					spawn_point.progress_ratio += spawn_step
					
		if PlayersSpawner.get_child_count() > players.keys().size():
			player_cards_generation()

		
func add_player_card(player_id):
	var player: Player = PlayersSpawner.get_node(str(player_id))
	var new_player_card = player_game_card.instantiate()

	new_player_card.player_name = player.player_name
	new_player_card.player_id = player.player_id
	new_player_card.name = str(player.player_id)
		
	new_player_card.global_position = spawn_point.global_position
	player.info_update.connect(new_player_card.player_info_update)
	
	players_list.add_child(new_player_card)
	players[str(player_id)] = player.player_name


func _on_raise_menu_button_pressed() -> void:
	if raise_menu_button.text == "   Raise":
		raise_menu_button.text = "   Close"
		menu_animation_player.play("raise_menu_open")
	else:
		raise_menu_button.text = "   Raise"
		menu_animation_player.play_backwards("raise_menu_open")


func _on_dice_number_slider_value_changed(value: float) -> void:
	dice_number_slider_label.text = str(value)


func _on_raise_button_pressed() -> void:
	var face_value = dice_face_value_order.ordered_value
	var dice_number = dice_number_slider.value
	
	GameManager.raise_bet.rpc_id(1, multiplayer.get_unique_id(), face_value, dice_number)


func _on_chech_button_pressed() -> void:
	if raise_input_menu.visible:
		menu_animation_player.play_backwards("raise_menu_open")
		_on_raise_menu_button_pressed()
	
	GameManager.check_last_bet.rpc_id(1, multiplayer.get_unique_id())
	print("You are cheching last bet")
