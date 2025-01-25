extends Panel

@export var player_name: String:
	set(new_name):
		player_name_label.text = new_name
		
@export var player_name_label: Label

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
