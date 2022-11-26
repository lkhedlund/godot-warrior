class_name Defend
extends Ability

func perform(unit: Unit, _params={}) -> void:
	unit.is_defending = true
