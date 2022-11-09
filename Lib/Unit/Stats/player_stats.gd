class_name PlayerStats
extends Resource

export var current_level := 1 setget set_current_level

func set_current_level(new_level: int) -> void:
	current_level = new_level
	print(current_level)
	_send_update_event()
	
func _send_update_event() -> void:
	EventBus.emit_signal('player_stats_changed', self)
