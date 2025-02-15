extends Control

func _on_back_button_pressed() -> void:
	SceneSwitcher.change_scene_to_file("res://scenes/menues/main_menu.tscn")
