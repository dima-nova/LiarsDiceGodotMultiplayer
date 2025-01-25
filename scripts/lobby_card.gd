extends Panel

signal lobby_connect_button_signal

var lobby_name: String
var lobby_id: int
var author_id: int

@onready var title := %LobbyName
@onready var players_string := %PlayersList

func _ready() -> void:
	title.text = lobby_name

func _process(delta: float) -> void:
	pass


func _on_connect_button_pressed() -> void:
	lobby_connect_button_signal.emit(self.lobby_id)
