class_name Health
extends Ability

func perform(unit: Unit, params={}):
	var unit_health_text = "%s's health: %s" % [unit.name, str(unit.health)]
	EventBus.emit_signal("update_player_log", unit_health_text)
	return unit.health
