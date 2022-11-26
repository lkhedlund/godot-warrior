class_name Rest
extends Ability

var healing_amount := 4

func perform(unit: Unit, _params={}):
	unit.heal(healing_amount)
