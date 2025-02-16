extends Node


const LANGUAGES: Array = ["english", "ukrainian"]
const LANGUAGES_DICT: Dictionary = {"english": "en", "ukrainian": "uk"}

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"



func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("audio", "music_volume", 0.5)
		config.set_value("audio", "sfx_volume", 0.5)
		
		config.set_value("interface", "language", "english")
		
		config.save(SETTINGS_FILE_PATH)
		
	else:
		config.load(SETTINGS_FILE_PATH)
	
	
	# Set up settings
	
	# Interface
	var locale = LANGUAGES_DICT[load_interface_settings().language]
	TranslationServer.set_locale(locale)	
	
	
		
		
func save_audio_setting(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)	
	return audio_settings
	
	
func save_interface_setting(key: String, value):
	config.set_value("interface", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_interface_settings():
	var interface_settings = {}
	for key in config.get_section_keys("interface"):
		interface_settings[key] = config.get_value("interface", key)	
	return interface_settings
	
	
