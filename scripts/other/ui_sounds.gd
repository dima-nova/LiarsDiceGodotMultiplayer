extends Node

@onready var sounds = {
	&"UI_Hover": AudioStreamPlayer.new(),
	&"UI_Press": AudioStreamPlayer.new(),
}


func _ready() -> void:
	# Set up audio stream players and load sound files
	for sound_name in sounds.keys():
		sounds[sound_name].stream = load("res://assets/UI/sfx/" + str(sound_name) + ".wav")
		sounds[sound_name].bus = &"UI"
		
		add_child(sounds[sound_name])
	
	get_tree().node_added.connect(update_sound_connection)
	install_sounds(get_tree().current_scene)
	
	
func update_sound_connection(node: Node):
	if node.get_parent() == get_tree().root:
		print("Current scene updated")
		var node_ = get_tree().current_scene	
	
		# connecting signals to UI nodes
		install_sounds(node_)
		
func install_sounds(node: Node):
	for element in node.get_children():
		if element is Button:
			element.pressed.connect(ui_sfx_play.bind(&"UI_Press"))
			element.mouse_entered.connect(ui_sfx_play.bind(&"UI_Hover"))
		
		install_sounds(element)
	
func ui_sfx_play(sound_name: StringName) -> void:
	sounds[sound_name].play()
