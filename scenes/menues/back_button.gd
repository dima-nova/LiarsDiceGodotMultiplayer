extends Button

func _on_mouse_entered() -> void:
	scale += Vector2(0.08, 0.08)
	



func _on_mouse_exited() -> void:
	scale -= Vector2(0.08, 0.08)
