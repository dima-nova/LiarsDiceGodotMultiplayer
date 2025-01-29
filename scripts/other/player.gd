extends Node
class_name Player

signal info_update

@export var player_name: String
@export var player_id: int
	
		
@export var dices_number: int = 5:
	set(value):
		dices_number = value
		info_update.emit()
@export var dices: Array[int]
@export var is_move: bool = false


func _ready() -> void:
	pass
	
func roll_dices():
	var random = RandomNumberGenerator.new()
	dices = []
	for i in dices_number:
		random.randomize()
		var face_value = random.randi_range(1, 6)
		dices.append(face_value)
