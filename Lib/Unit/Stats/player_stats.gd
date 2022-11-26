class_name PlayerStats
extends Resource

export var current_level := 0 setget set_current_level
export var extra_logging := true setget set_extra_logs
export var new_game_plus := false setget set_new_game_plus
var unlocked_abilities := {} setget set_unlocked_abilities

func _ready() -> void:
	EventBus.connect("game_over", self, "_on_Game_Over")

func has_unlocked(ability_name: String) -> bool:
	return unlocked_abilities.has(ability_name)

func set_current_level(new_level: int) -> void:
	if new_level == current_level: return

	current_level = new_level
	_send_update_event()

func set_unlocked_abilities(new_abilities: Dictionary) -> void:
	if unlocked_abilities == new_abilities: return

	unlocked_abilities = new_abilities
	EventBus.emit_signal("abilities_unlocked", unlocked_abilities)
	
	_send_update_event()

func set_extra_logs(value: bool) -> void:
	extra_logging = value
	_send_update_event()
	
func set_new_game_plus(value: bool) -> void:
	new_game_plus = value
	_send_update_event()

func _send_update_event() -> void:
	EventBus.emit_signal('player_stats_changed', self)

func _on_Game_Over(type: String, _extra_text: String) -> void:
	if type == "win":
		new_game_plus = true
