extends Node

var audio_effects_dict = {
	"UI_Hover": AudioStreamPlayer2D.new(),
	"UI_Press": AudioStreamPlayer2D.new()
}

func _ready() -> void:
	for audio in audio_effects_dict.keys():
		audio_effects_dict[audio].stream = load("res://assets/UI/sfx/" + str(audio) + ".wav")
		add_child(audio_effects_dict[audio])
	
func play_sound(sound_name):
	if sound_name == "UI_Hover":
		return
	if audio_effects_dict[sound_name]:
		audio_effects_dict[sound_name].play()

func _process(delta: float) -> void:
	pass
