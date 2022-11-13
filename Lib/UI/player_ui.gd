extends Control

onready var play_button = $BottomContainer/PlayerButtons/PlayButton
onready var player_log = $BottomContainer/PlayerOutput/PlayerLog
onready var menu_popup = $MainModal
onready var abilities_popup = $AbilitiesModal
onready var new_ability_icon = $BottomContainer/PlayerButtons/AbilitiesButton/NewIcon

func _ready() -> void:
	EventBus.connect("update_player_log", self, "_on_Player_Log_update")
	EventBus.connect("exit_level", self, "_on_Exit_level")
	EventBus.connect("ability_gained", self, "_on_Ability_gained")
	# Reset player log
	player_log.bbcode_text = ""

func _on_Exit_level() -> void:
	play_button.disabled = false
	player_log.text = ""

func _on_Player_Log_update(new_line: String, log_type: String = "default") -> void:
	if not player_log.bbcode_text.empty():
		player_log.bbcode_text += "\n"
	player_log.bbcode_text += format_log(log_type, new_line)

func format_log(log_type: String, new_line: String) -> String:
	var formatted_line = "> %s" % new_line
	match log_type:
		"hint":
			return "[color=aqua][HINT] %s[/color]" % formatted_line
	return formatted_line
	
# Signals
func _on_Ability_gained(new_ability: Resource) -> void:
	new_ability_icon.visible = true
	abilities_popup.add_ability_to_list(new_ability)
	
func _on_PlayButton_pressed():
	play_button.disabled = true
	EventBus.emit_signal("play_button_pressed")
	
func _on_MenuButton_pressed():
	menu_popup.open_menu()

func _on_AbilitiesButton_pressed() -> void:
	new_ability_icon.visible = false
	abilities_popup.open_menu()
