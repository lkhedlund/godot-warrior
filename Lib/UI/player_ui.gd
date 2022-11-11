extends Control

onready var play_button = $BottomContainer/PlayerButtons/PlayButton
onready var player_log = $BottomContainer/PlayerOutput/PlayerLog
onready var menu_popup = $MenuPopup

func _ready() -> void:
	EventBus.connect("update_player_log", self, "_on_Player_Log_update")
	EventBus.connect("exit_level", self, "_on_Exit_level")
	# Reset player log
	player_log.text = ""

func _on_PlayButton_pressed():
	play_button.disabled = true
	EventBus.emit_signal("play_button_pressed")
	
func _on_MenuButton_pressed():
	menu_popup.open_menu()

func _on_Exit_level() -> void:
	play_button.disabled = false
	player_log.text = ""

func _on_Player_Log_update(new_line: String) -> void:
	if not player_log.text.empty():
		player_log.text += "\n"
	player_log.text += "> %s" % new_line
