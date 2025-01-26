extends Node2D

@export var player_name_label: Label

var player_name: String:
	set(new_name):
		player_name = new_name
		player_name_label.text = new_name.substr(0, 5)
		
var player_id: int
var is_move: bool


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
