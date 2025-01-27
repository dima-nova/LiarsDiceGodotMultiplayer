extends Node2D

@export_group("Nodes")
@export var player_name_label: Label
@export var main_panel: Panel
@export var animation_player: AnimationPlayer
@export var dices_number_label: Label

var player_name: String:
	set(new_name):
		player_name = new_name
		player_name_label.text = new_name.substr(0, 5)	
var player_id: int
var is_move: bool = false:
	set(value):
		if value:
			animation_player.play("move")
var dices_number: int = 5:
	set(value):
		dices_number_label.text = str(value)
			
var player: Player


func _ready() -> void:
	player = PlayersSpawner.get_node(str(player_id))

	
func player_info_update():
	is_move = player.is_move
	dices_number = player.dices_number
