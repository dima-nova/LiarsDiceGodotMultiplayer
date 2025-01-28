extends Control

@export var animated_sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer


func _ready() -> void:
	pass 


func set_dice_value(number: int):
	number = clamp(number, 1, 6)
	animated_sprite.play(str(number))
	
func roll():
	animation_player.play("roll")
	
func update_roll():
	animation_player.play("update_roll")
	
