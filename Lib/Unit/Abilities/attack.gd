class_name Attack
extends Ability

export var damage := 10

func do_damage(unit: Unit) -> void:
	unit.set_health(damage)
	var new_line = "%s took %s damage" % [unit.name, str(damage)]
	EventBus.emit_signal("update_player_log", new_line)
