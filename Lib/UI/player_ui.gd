extends Control

var player_stats

@export var sound_on: Texture2D
@export var sound_off: Texture2D

@onready var play_button = $BottomContainer/PlayerButtons/PlayButton
@onready var player_log = $BottomContainer/PlayerOutput/PlayerLog
@onready var menu_popup = $MainModal
@onready var abilities_popup = $AbilitiesModal
@onready var new_ability_icon = $BottomContainer/PlayerButtons/AbilitiesButton/NewIcon
@onready var credits_popup = $CreditsModal
@onready var sound_button = $HBoxContainer/SoundButton

func _ready() -> void:
	EventBus.connect("update_player_log",Callable(self,"_on_Player_Log_update"))
	EventBus.connect("exit_level",Callable(self,"_on_Exit_level"))
	EventBus.connect("abilities_unlocked",Callable(self,"_on_abilities_unlocked"))
	player_stats = GameManager.player_stats
	# Reset player log
	player_log.text = ""
	toggle_sound_icon(player_stats.play_music)

func _on_Exit_level() -> void:
	play_button.disabled = false
	player_log.text = ""

func _on_Player_Log_update(new_line: String, log_type: String = "default") -> void:
	var base_line = "> %s" % new_line
	var formatted = base_line
	match log_type:
		"hint":
			formatted = "[color=aqua]HINT %s[/color]" % base_line
		"extra":
			if not GameManager.player_stats.extra_logging: return
	if not player_log.text.is_empty():
		player_log.text += "\n"
	player_log.text += formatted
	
func toggle_sound_icon(state: bool) -> void:
	if state == false:
		sound_button.icon = sound_off
	else:
		sound_button.icon = sound_on
	
# Signals
func _on_PlayButton_pressed():
	play_button.disabled = true
	EventBus.emit_signal("play_button_pressed")
	
func _on_MenuButton_pressed():
	menu_popup.open_menu()
	
func _on_abilities_unlocked(abilities: Dictionary) -> void:
	for key in abilities:
		var ability = abilities[key]
		if ability.level_unlocked == player_stats.current_level:
			new_ability_icon.visible = true
		abilities_popup.add_ability_to_list(ability)

func _on_AbilitiesButton_pressed() -> void:
	new_ability_icon.visible = false
	abilities_popup.open_menu()

func _on_MainModal_credits_opened():
	credits_popup.open_menu()

func _on_SoundButton_toggled(button_pressed):
	toggle_sound_icon(button_pressed)
	player_stats.play_music = button_pressed
