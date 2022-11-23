class_name PlayerStats
extends Resource

export var current_level := 0 setget set_current_level
export(Array) var unlocked_abilities: Array
export var extra_logging := true setget set_extra_logs

func has_unlocked(ability_name: String) -> bool:
	return unlocked_abilities.has(ability_name)

func set_current_level(new_level: int) -> void:
	if new_level == current_level: return

	current_level = new_level
	_send_update_event()

func set_ability(new_ability: Resource) -> void:
	if has_unlocked(new_ability.name): return
	
	unlocked_abilities.append(new_ability.name)
	_send_update_event()

func set_extra_logs(value: bool) -> void:
	extra_logging = value
	_send_update_event()
	
func _send_update_event() -> void:
	EventBus.emit_signal('player_stats_changed', self)
