extends Node2D

@export_group("UI")
@export var player_game_card: PackedScene
@export var spawn_point: PathFollow2D
@export var players_list: Node2D
@export var main_bet_dice: Node2D
@export var main_bet_value_label: Label
@export var dices_list: Node2D
@export var animation_player: AnimationPlayer
@export var raise_menu_button: Button
@export var action_buttons: HBoxContainer
@export var waiting_label: Label
@export var dice_number_slider: HSlider
@export var dice_number_slider_label: Label
@export var dice_face_value_order: Control
@export var raise_input_menu: Control

var players: Dictionary
var spawn_step: float
		


func _ready() -> void:
	# Connecting signals
	GameManager.bet_update.connect(update_bet)
	GameManager.round_starting.connect(update_dices)
	GameManager.next_turn.connect(make_turn_possibility)
	
	# Spawn player cards
	spawn_point.progress_ratio = 0.0
	spawn_step = 1.0 / PlayersSpawner.get_child_count()
	player_cards_generation()
	
	# Updating start bet
	update_bet()
	
	# Updating dices
	update_dices()
	
	# Making turn possible
	make_turn_possibility()

	
func update_bet():
	main_bet_dice.update_roll()
	main_bet_dice.set_dice_value(GameManager.current_face_value)
	main_bet_value_label.text = str(GameManager.current_bet_number)
	
	
	dice_number_slider.min_value = GameManager.current_bet_number
	dice_number_slider.value = dice_number_slider.min_value
	dice_number_slider.max_value = dice_number_slider.min_value + 10
	
	dice_number_slider_label.text = str(dice_number_slider.min_value)
	
	dice_face_value_order.ordered_value = GameManager.current_face_value
	
	
func update_dices():
	var player_dices = PlayersSpawner.get_node(str(multiplayer.get_unique_id())).dices
	for dice_i in dices_list.get_child_count():
		dices_list.get_child(dice_i).roll()
		dices_list.get_child(dice_i).set_dice_value(player_dices[dice_i])
		

func make_turn_possibility():
	if PlayersSpawner.get_child(GameManager.current_player_id).player_id == multiplayer.get_unique_id():
		waiting_label.hide()
		action_buttons.visible = true
		raise_input_menu.visible = true
	else:
		if raise_input_menu.visible:
			print("There!")
			animation_player.play_backwards("raise_menu_open")
			print(raise_input_menu.visible)
			_on_raise_menu_button_pressed()
		action_buttons.hide()
		waiting_label.visible = true
			

func player_cards_generation():
	"""This function generate players cards on the game field"""
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
		
	new_player_card.global_position = spawn_point.global_position
	player.info_update.connect(new_player_card.player_info_update)
	
	players_list.add_child(new_player_card)
	players[str(player_id)] = player.player_name


func _on_raise_menu_button_pressed() -> void:
	if raise_menu_button.text == "   Raise":
		raise_menu_button.text = "   Close"
		animation_player.play("raise_menu_open")
	else:
		raise_menu_button.text = "   Raise"
		animation_player.play_backwards("raise_menu_open")


func _on_dice_number_slider_value_changed(value: float) -> void:
	dice_number_slider_label.text = str(value)


func _on_raise_button_pressed() -> void:
	var face_value = dice_face_value_order.ordered_value
	var dice_number = dice_number_slider.value
	
	GameManager.raise_bet.rpc_id(1, multiplayer.get_unique_id(), face_value, dice_number)


func _on_chech_button_pressed() -> void:
	print("You are cheching last bet")
