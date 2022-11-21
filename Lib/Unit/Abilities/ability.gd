class_name Ability
extends Resource

export var name: String
export(String, MULTILINE) var description
export var ability_range := 1
export var action_cost := 1
export var cooldown := 0
export var is_on_cooldown := false

func perform(_unit: Unit, _params={}):
	pass
