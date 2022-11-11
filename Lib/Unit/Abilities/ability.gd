class_name Ability
extends Resource

export var name: String
export(String, MULTILINE) var description
export var ability_range := 1
export var action_cost := 1

func perform(unit: Unit, _params={}):
	pass
