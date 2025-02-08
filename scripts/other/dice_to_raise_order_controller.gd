extends Control

@export var dice_button_1: Button
@export var dice_button_2: Button
@export var dice_button_3: Button
@export var dice_button_4: Button
@export var dice_button_5: Button
@export var dice_button_6: Button

var ordered_button: Button
var ordered_value: int:
	set(new_value):
		ordered_value = new_value
		if ordered_button:
			ordered_button.disabled = false
		ordered_button = get_node("Dices/DiceButton" + str(new_value))
		ordered_button.disabled = true


func _on_dice_button_1_pressed() -> void:
	if ordered_button:
		ordered_button.disabled = false
	ordered_button = dice_button_1
	ordered_button.disabled = true
	ordered_value = 1


func _on_dice_button_2_pressed() -> void:
	if ordered_button:
		ordered_button.disabled = false
	ordered_button = dice_button_2
	ordered_button.disabled = true
	ordered_value = 2


func _on_dice_button_3_pressed() -> void:
	if ordered_button:
		ordered_button.disabled = false
	ordered_button = dice_button_3
	ordered_button.disabled = true
	ordered_value = 3


func _on_dice_button_4_pressed() -> void:
	if ordered_button:
		ordered_button.disabled = false
	ordered_button = dice_button_4
	ordered_button.disabled = true
	ordered_value = 4


func _on_dice_button_5_pressed() -> void:
	if ordered_button:
		ordered_button.disabled = false
	ordered_button = dice_button_5
	ordered_button.disabled = true
	ordered_value = 5

func _on_dice_button_6_pressed() -> void:
	if ordered_button:
		ordered_button.disabled = false
	ordered_button = dice_button_6
	ordered_button.disabled = true
	ordered_value = 6
