extends Control

@export var music_volume_slider: HSlider
@export var sfx_volume_slider: HSlider

@export var language_option_button: OptionButton

func _ready() -> void:
	language_options_generation()
	load_settings()

	
func load_settings():
	var audio_settings: Dictionary = ConfigFileHandler.load_audio_settings()
	music_volume_slider.value = min(audio_settings.music_volume, 1.0) * 100
	sfx_volume_slider.value = min(audio_settings.sfx_volume, 1.0) * 100
	
	var interface_settings: Dictionary = ConfigFileHandler.load_interface_settings()
	language_option_button.select(ConfigFileHandler.LANGUAGES.find(interface_settings.language))

	
func language_options_generation():
	language_option_button.clear()
	
	for language in ConfigFileHandler.LANGUAGES:
		language_option_button.add_item(language)
		

func _on_back_button_pressed() -> void:
	SceneSwitcher.change_scene_to_file("res://scenes/menues/main_menu.tscn")


func _on_music_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("music_volume", music_volume_slider.value / 100)
		

func _on_sfx_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("sfx_volume", sfx_volume_slider.value / 100)


func _on_option_language_button_item_selected(index: int) -> void:
	ConfigFileHandler.save_interface_setting("language", ConfigFileHandler.LANGUAGES[index])
