extends Node2D

@export_group("UI")
@export var player_name_label: Label
@export var main_panel: Panel
@export var own_card_panel: Panel

var player_name: String:
	set(new_name):
		player_name = new_name
		player_name_label.text = new_name.substr(0, 5)
		
var player_id: int
var is_own_card: bool = false:
	set(value):
		if value == true:
			main_panel.hide()
			own_card_panel.visible = true
		else:
			own_card_panel.hide()
			main_panel.visible = true
			
var is_move: bool


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
