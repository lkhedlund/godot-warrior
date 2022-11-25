class_name Ability
extends Resource

export var name: String
export(String, MULTILINE) var description
export var ability_range := 1
export var action_cost := 1
export var level_unlocked := 0

func perform(_unit: Unit, _params={}):
	pass
