class_name PlayerStats
extends Resource

export var current_level := 1 setget set_current_level
export(Array, Resource) var abilities: Array

func set_current_level(new_level: int) -> void:
	current_level = new_level
	print(current_level)
	_send_update_event()

func set_ability(new_ability: Resource) -> void:
	if abilities.has(new_ability): return

	abilities.append(new_ability)
	_send_update_event()
	
func _send_update_event() -> void:
	EventBus.emit_signal('player_stats_changed', self)
