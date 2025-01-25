extends Control

@onready var exit_button_sprite := %ExitButton
@onready var profile_button_sprite := %ProfileButton

const SCALE_VALUE = 0.08


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MultiplayerManager.connected_to_server_signal.connect(connected_to_server)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_tree().quit()


func _on_profile_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			SfxController.play_sound("UI_Press")
			print("Profile is opening")
			
#Animations
func _on_exit_area_mouse_entered() -> void:
	exit_button_sprite.scale += Vector2(SCALE_VALUE, SCALE_VALUE)
	SfxController.play_sound("UI_Hover")
	

func _on_exit_area_mouse_exited() -> void:
	exit_button_sprite.scale -= Vector2(SCALE_VALUE, SCALE_VALUE)


func _on_profile_area_mouse_entered() -> void:
	profile_button_sprite.scale += Vector2(SCALE_VALUE, SCALE_VALUE)
	SfxController.play_sound("UI_Hover")
	
	
func _on_profile_area_mouse_exited() -> void:
	profile_button_sprite.scale -= Vector2(SCALE_VALUE, SCALE_VALUE)


# Main Buttons
func _on_start_button_pressed() -> void:
	SfxController.play_sound("UI_Press")
	var response = MultiplayerManager.join_game()
	if response == true:
		pass
	else:
		print("Server not response")
		
func connected_to_server():
	get_tree().change_scene_to_file("res://scenes/menues/room_menu.tscn")
	

func _on_settings_button_pressed() -> void:
	SfxController.play_sound("UI_Press")
	print("Settings")
	

func _on_help_button_pressed() -> void:
	SfxController.play_sound("UI_Press")
	print("Help")


func _on_start_button_mouse_entered() -> void:
	SfxController.play_sound("UI_Hover")


func _on_settings_button_mouse_entered() -> void:
	SfxController.play_sound("UI_Hover")


func _on_help_button_mouse_entered() -> void:
	SfxController.play_sound("UI_Hover")


func _on_run_dedicated_server_button_pressed() -> void:
	MultiplayerManager.create_server()
	print("Server started...")
