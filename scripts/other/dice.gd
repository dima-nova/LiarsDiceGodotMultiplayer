extends Node2D

@export var animated_sprite: AnimatedSprite2D


func _ready() -> void:
	pass 


func set_dice_value(number: int):
	number = clamp(number, 1, 6)
	animated_sprite.play(str(number))
	
