class_name PlayerStats
extends Resource

export var current_level := 0 setget set_current_level
export(Array) var unlocked_abilities: Array

func set_current_level(new_level: int) -> void:
	if new_level == current_level: return

	current_level = new_level
	_send_update_event()

func set_ability(new_ability: Resource) -> void:
	if unlocked_abilities.has(new_ability.name): return
	
	unlocked_abilities.append(new_ability.name)
	EventBus.emit_signal("ability_gained", new_ability)
	_send_update_event()
	
func _send_update_event() -> void:
	EventBus.emit_signal('player_stats_changed', self)
