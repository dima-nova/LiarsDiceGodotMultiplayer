extends Control

@onready var switch_to_create_lobby_button := %SwitchToCreateLobbyButton
@onready var switch_to_lobbies_button := %SwitchToLobbiesButton

@onready var create_lobby_menu := %CreateLobbyMenu
@onready var lobbies_order_menu := %LobbiesOrderMenu
@onready var authority_order_menu := %AuthorityOrderMenu
@onready var menues_order_button := %MenuesOrderButtons
@onready var lobbies_list := %LobbiesList

@onready var lobby_name_edit_line := %NameEditLine
@onready var lobby_max_players_value_edit_line := %MaxPlayersEditLine

@onready var guest_name_line_edit := %GuestNameLineEdit

var lobby_card = load("res://scenes/menues/lobby_card.tscn")
@onready var lobbies_spawner := get_tree().root.get_node("/root/LobbiesSpawner")

func _ready() -> void:
	MultiplayerManager.lobby_update.connect(lobbies_ui_update)
	print("lobbies there ->")
	
func _process(delta: float) -> void:
	for lobby_i in lobbies_spawner.get_children():
		var lobby_card_i = lobbies_list.get_node(str(lobby_i.lobby_id))
		if lobby_card_i:
			lobby_card_i.players_string.text = "Players: " + ", ".join(lobby_i.players_id_dict.values())
			
func lobbies_ui_update(lobby_to_update_id=null):
	print("lobby updating")

	if lobbies_spawner.get_child_count() < MultiplayerManager.lobbies.size():
		print("Deleting lobby...")
		for lobby_i in lobbies_list.get_children():
			if !str(lobby_i.lobby_id) in lobbies_spawner.get_children().map(func(child): return child.name):
				print("deleting lobby card with id: " + lobby_i.name)
				lobby_i.queue_free()
				MultiplayerManager.lobbies.erase(lobby_i.lobby_id)
	
	for lobby in lobbies_spawner.get_children():
		if lobby is Lobby and !lobby.lobby_id in MultiplayerManager.lobbies:
			var new_lobby_card = lobby_card.instantiate()
			new_lobby_card.lobby_name = lobby.lobby_name
			new_lobby_card.lobby_id = lobby.lobby_id
			new_lobby_card.name = str(lobby.lobby_id)
			
			lobbies_list.add_child(new_lobby_card)
			MultiplayerManager.lobbies.append(lobby.lobby_id)
			
			new_lobby_card.lobby_connect_button_signal.connect(add_player_to_lobby)
			
			
func add_player_to_lobby(lobby_id: int):
	MultiplayerManager.add_player_to_lobby.rpc_id(1, multiplayer.get_unique_id(), lobby_id)


func _on_switch_to_create_lobby_button_pressed() -> void:
	lobbies_order_menu.hide()
	create_lobby_menu.visible = true
	
	switch_to_create_lobby_button.disabled = true
	switch_to_lobbies_button.disabled = false
	switch_to_create_lobby_button.z_index = 1
	switch_to_lobbies_button.z_index = 0
	

func _on_switch_to_lobbies_button_pressed() -> void:
	create_lobby_menu.hide()
	lobbies_order_menu.visible = true
	
	switch_to_lobbies_button.disabled = true
	switch_to_create_lobby_button.disabled = false
	switch_to_create_lobby_button.z_index = 0
	switch_to_lobbies_button.z_index = 1


func _on_create_lobby_button_pressed() -> void:
	var lobby_name = lobby_name_edit_line.text
	var lobby_max_players_value = lobby_max_players_value_edit_line.text.to_int()
	var author_id = multiplayer.get_unique_id()
	
	if lobby_max_players_value:
		print("Create Lobby Button pressed")
		MultiplayerManager.create_lobby.rpc_id(1, lobby_name, lobby_max_players_value, author_id)
	
	# TODO make scene transition to lobby waiting scene
	
	
func _on_play_as_guest_button_pressed() -> void:
	var guest_name = guest_name_line_edit.text
	AccountManager.set_guest_name(guest_name)
	
	authority_order_menu.hide()
	lobbies_order_menu.visible = true
	menues_order_button.visible = true
