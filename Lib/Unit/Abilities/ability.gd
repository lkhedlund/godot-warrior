class_name Ability
extends Resource

@export var name: String
@export var description # (String, MULTILINE)
@export var ability_range := 1
@export var action_cost := 1
@export var level_unlocked := 0

# warning-ignore:unused_argument
func perform(unit: Unit, _params={}):
	pass
