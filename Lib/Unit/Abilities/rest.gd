class_name Rest
extends Ability

var healing_amount := 3

func perform(unit: Unit, _params={}):
	unit.heal(healing_amount)
